DELIMITER //

-- Procedure 1: Checks inventory and fulfills a pending Request if resources are available at any center.
CREATE PROCEDURE FulfillRequestIfAvailable (
    IN request_id_param INT
)
BEGIN
    DECLARE needed_quantity INT;
    DECLARE resource_type_param VARCHAR(50);
    DECLARE available_quantity INT;
    DECLARE center_id_to_use INT;

    SELECT Quantity, ResourceType INTO needed_quantity, resource_type_param
    FROM Request
    WHERE RequestID = request_id_param AND Status = 'Pending';

    SELECT CenterID, Quantity INTO center_id_to_use, available_quantity
    FROM Resource
    WHERE ResourceType = resource_type_param AND Quantity >= needed_quantity
    LIMIT 1;

    START TRANSACTION;

    IF center_id_to_use IS NOT NULL THEN
        -- 1. Update Resource (inventory deduction, guarded by Trigger 3)
        UPDATE Resource
        SET Quantity = Quantity - needed_quantity
        WHERE CenterID = center_id_to_use AND ResourceType = resource_type_param;

        -- 2. Update Request status (triggers Trigger 2)
        UPDATE Request
        SET Status = 'Fulfilled'
        WHERE RequestID = request_id_param;

        COMMIT;
        SELECT CONCAT('Request ID ', request_id_param, ' fulfilled from Center ID ', center_id_to_use, '.') AS Message;
    ELSE
        ROLLBACK;
        SELECT CONCAT('Error: Insufficient stock of ', resource_type_param, ' available to fulfill Request ID ', request_id_param, '.') AS Message;
    END IF;

END; //

-- Procedure 2: Retrieves essential contact and capacity information for a specific relief center.
CREATE PROCEDURE GetCenterContactDetails (
    IN center_id_param INT
)
BEGIN
    SELECT
        CenterName,
        Location,
        Capacity,
        ContactNumber,
        ManagerName
    FROM ReliefCenter
    WHERE CenterID = center_id_param;
END; //

DELIMITER ;