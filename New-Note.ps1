Param(
    [string]$project = "",
    [string]$noteText = "test"
)

process
{
    $apiUrl = "https://todoist.com/API/v7/sync"
    $key = "e4008326dc27dd5ecc36770da50cebd902136ea1"
    function New-TestNote
    {
        $postParams = @{token="$key";
                        commands = '[{"type": "item_add", "temp_id": "43f7ed23-a038-46b5-b2c9-4abda9097ffa", "uuid": "997d4b43-55f1-48a9-9e66-de5785dfd69c", "args": {"content": "Task1"}}]'}
        Invoke-WebRequest -Uri $apiUrl -Method POST -Body $postParams
    }

    function Main
    {
        New-TestNote
    }
    main

}

