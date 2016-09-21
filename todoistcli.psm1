function New-Note
{
    [CmdletBinding()]
        Param(
                [string]$project = "Inbox",
                [string]$label = "work",
                [int]$priority = 1,
                [string]$noteText = "test"
             )

            process
            {

                    $labels = Get-Labels
                    $projects = Get-Projects
                    $projects = ConvertTo-Hash($projects)
                    $labels = ConvertTo-Hash($labels)

                    $commandString = ConvertFrom-Json "[{}]"

                    $commandString[0] | add-member -name "uuid" -value $([guid]::NewGuid()) -MemberType NoteProperty
                    $commandString[0] | add-member -name "temp_id" -value $([guid]::NewGuid()) -MemberType NoteProperty

                    $commandString[0] | add-member -name "type" -value "item_add" -MemberType NoteProperty

                    $cmdArgs = @{ content = $noteText ; project_id = $projects[$project] ; labels = @($labels[$label]) ; priority = $priority}
                $commandString[0] | add-member -name "args" -value $cmdArgs -MemberType NoteProperty


                    $commandStringFinal = ($commandString) | ConvertTo-Json -Depth 20 -Compress

# make array TODO FIX THIS 
                    $final = "[" + $commandStringFinal + "]"

                    $postParams = @{
                        token="$env:TodoistApiKey";
                        commands = "$final"
                    }
                $res = Hit-Api($postParams)
                    $res.StatusDescription

            }
}
function Get-Labels
{
    $postParams = @{token="$env:TodoistApiKey";
        sync_token="*";
        resource_types = '["labels"]'
    }
    $res = Hit-Api($postParams)
        $js = ConvertFrom-Json $res.Content
        return $js.labels
}

function Get-Projects
{
    $postParams = @{token="$env:TodoistApiKey";
        sync_token="*";
        resource_types = '["projects"]'
    }
    $res = Hit-Api($postParams)
        $js = ConvertFrom-Json $res.Content
        return $js.Projects
}
function ConvertTo-Hash($jsArray)
{
    $hash = @{}
    foreach ($obj in $jsArray)
    {
        $hash[$obj.name] = $obj.id
    }
    return $hash
}
function Hit-Api($params)
{
    try
    {
        $res = Invoke-WebRequest -Uri $env:TodoistApiUrl -Method POST -Body $params
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            $Stack = $_.Exception.StackTrace
            Write-Host $ErrorMessage
            Write-Host $FailedItem
            Write-Host $Stack
    }
    return $res
}

$env:TodoistApiUrl = "https://todoist.com/API/v7/sync"
$env:TodoistApiKey = "e4008326dc27dd5ecc36770da50cebd902136ea1"

export-modulemember -function New-Note
export-modulemember -function Get-Labels
export-modulemember -function Get-Projects
