# Path to the file containing the list of repository paths
$repoList = "C:\Users\CAPRICON\Desktop\Documentation\repos.txt"

# Destination folder where all repositories will be cloned
$destinationDir = "C:\git\Devops_Tools\Gitea_Repositories_Backup\Gita_Repository_Backup"

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -Path $destinationDir -ItemType Directory
}

# Read the repository list from the text file
$repos = Get-Content -Path $repoList

# Loop through each repository URL
foreach ($repoUrl in $repos) {
    # Extract the relative path (assuming the part after "gitea-repositories" is the folder structure)
    $relativePath = $repoUrl -replace ".*\\gitea-repositories\\", ""

    # Remove the ".git" extension and extract the repository name
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($repoUrl)

    # Create the full path where the repository will be cloned
    $clonePath = Join-Path $destinationDir $relativePath

    # Check if the directory already exists
    if (-not (Test-Path -Path $clonePath)) {
        # Create the directory structure for the repository
        New-Item -Path $clonePath -ItemType Directory -Force

        # Clone the repository into the newly created folder
        Write-Host "Cloning $repoName into $clonePath..."
        git clone $repoUrl $clonePath

        # Check if the cloning succeeded
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully cloned $repoName"
        } else {
            Write-Host "Failed to clone $repoName" -ForegroundColor Red
        }
    } else {
        Write-Host "Directory $clonePath already exists, skipping..."
    }
}

Write-Host "All repositories processed."

# Pause the screen and wait for user input
Read-Host -Prompt "Press Enter to exit"
