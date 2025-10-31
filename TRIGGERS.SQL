DELIMITER //

-- Trigger 1: Updates Resource inventory when a new Donation is inserted.
CREATE TRIGGER after_donation_insert
AFTER INSERT ON Donation
FOR EACH ROW
BEGIN
    -- Check if the donated resource type already exists at the center
    IF EXISTS (
        SELECT 1 FROM Resource
        WHERE ResourceType = NEW.ResourceType AND CenterID = NEW.CenterID
    ) THEN
        -- If it exists, increase the quantity
        UPDATE Resource
        SET Quantity = Quantity + NEW.Quantity
        WHERE ResourceType = NEW.ResourceType AND CenterID = NEW.CenterID;
    ELSE
        -- If it's a new resource type, insert a new record
        INSERT INTO Resource (ResourceName, ResourceType, Quantity, Unit, CenterID)
        VALUES (
            CONCAT(NEW.ResourceType, ' Stock'),
            NEW.ResourceType,
            NEW.Quantity,
            'Units', -- Default unit for simplicity
            NEW.CenterID
        );
    END IF;
END; //

-- Trigger 2: Deducts inventory when a Request status is updated to 'Fulfilled'.
CREATE TRIGGER after_request_fulfillment
AFTER UPDATE ON Request
FOR EACH ROW
BEGIN
    -- Check if the status was just changed to 'Fulfilled'
    IF NEW.Status = 'Fulfilled' AND OLD.Status != 'Fulfilled' THEN
        -- Deduct from the first matching resource found. (Requires manual check in a real app)
        UPDATE Resource
        SET Quantity = Quantity - NEW.Quantity
        WHERE ResourceType = NEW.ResourceType
        LIMIT 1;
    END IF;
END; //

-- Trigger 3: Prevents Resource Quantity from being updated to a negative value.
CREATE TRIGGER before_resource_update
BEFORE UPDATE ON Resource
FOR EACH ROW
BEGIN
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Cannot reduce resource quantity below zero. Insufficient stock available.';
    END IF;
END; //

-- Trigger 4: Sets a ReliefCenter status to 'Active' if a Volunteer is assigned to it and it was 'Inactive'.
CREATE TRIGGER after_volunteer_insert
AFTER INSERT ON Volunteer
FOR EACH ROW
BEGIN
    DECLARE center_status VARCHAR(20);

    IF NEW.CenterID IS NOT NULL THEN
        SELECT Status INTO center_status
        FROM ReliefCenter
        WHERE CenterID = NEW.CenterID;

        IF center_status = 'Inactive' THEN
            UPDATE ReliefCenter
            SET Status = 'Active'
            WHERE CenterID = NEW.CenterID;
        END IF;
    END IF;
END; //

-- Trigger 5: Enforces that new Donations must be assigned to an Active Relief Center.
CREATE TRIGGER before_donation_insert_enforce_center
BEFORE INSERT ON Donation
FOR EACH ROW
BEGIN
    DECLARE center_status VARCHAR(20);

    IF NEW.CenterID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: All incoming donations must be assigned to a specific Relief Center.';
    ELSE
        SELECT Status INTO center_status
        FROM ReliefCenter
        WHERE CenterID = NEW.CenterID;

        IF center_status = 'Inactive' THEN
             SIGNAL SQLSTATE '45000'
             SET MESSAGE_TEXT = 'ERROR: Cannot accept donation at an Inactive Relief Center.';
        END IF;
    END IF;
END; //

DELIMITER ;