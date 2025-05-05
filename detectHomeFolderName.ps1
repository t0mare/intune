$allowedPattern = '^[a-zA-Z0-9_.-]+$'

# Get the current user's profile path (e.g., C:\Users\John.Doe)
$userProfilePath = $env:USERPROFILE

if ([string]::IsNullOrEmpty($userProfilePath)) {
    Write-Error "Could not determine user profile path."
    # Exit with error code 1 to indicate a problem/detection state in Intune
    exit 1
}

# Extract just the folder name (e.g., John.Doe)
try {
    $usernameFolder = Split-Path -Leaf $userProfilePath -ErrorAction Stop
} catch {
    Write-Error "Error splitting path '$userProfilePath': $($_.Exception.Message)"
    # Exit with error code 1 to indicate a problem/detection state in Intune
    exit 1
}

# Check if the folder name ONLY contains allowed characters
if ($usernameFolder -match $allowedPattern) {
    # Name is compliant (only contains allowed characters)
    Write-Output "User profile folder name '$usernameFolder' is compliant."
    # Exit with 0 for Intune to indicate "No issue detected"
    exit 0
} else {
    # Name is NOT compliant (contains special characters)
    Write-Warning "User profile folder name '$usernameFolder' contains special or disallowed characters."
    # Exit with 1 for Intune to indicate "Issue detected"
    exit 1
}
