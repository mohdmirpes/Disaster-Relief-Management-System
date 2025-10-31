DELIMITER //

-- Function 1: Calculates the current total quantity of a specific resource type across all Active relief centers.
CREATE FUNCTION GetTotalResourceStock (
    resource_type_param VARCHAR(50)
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_stock INT;

    SELECT SUM(R.Quantity) INTO total_stock
    FROM Resource R
    JOIN ReliefCenter RC ON R.CenterID = RC.CenterID
    WHERE R.ResourceType = resource_type_param
      AND RC.Status = 'Active';

    RETURN IFNULL(total_stock, 0);
END; //

-- Function 2: Counts how many requests for a specific event are still in 'Pending' status.
CREATE FUNCTION CountActiveRequestsForEvent (
    event_id_param INT
)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE pending_requests INT;

    SELECT COUNT(RequestID) INTO pending_requests
    FROM Request
    WHERE EventID = event_id_param
      AND Status = 'Pending';

    RETURN pending_requests;
END; //

DELIMITER ;