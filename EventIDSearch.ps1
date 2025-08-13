# Load assemblies
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing

# Define categories, event IDs, and meanings
$categories = @{
    "AccountActivity" = @{ 
        Log = "Security"; 
        IDs = @(
            @{ ID = 4624; Meaning = "Successful logon" },
            @{ ID = 4625; Meaning = "Failed logon attempt" },
            @{ ID = 4634; Meaning = "Logoff" },
            @{ ID = 4647; Meaning = "User-initiated logoff" },
            @{ ID = 4648; Meaning = "Explicit credentials used" },
            @{ ID = 4672; Meaning = "Security ID assigned to user" },
            @{ ID = 4768; Meaning = "Kerberos TGT request" },
            @{ ID = 4769; Meaning = "Kerberos service ticket request" },
            @{ ID = 4771; Meaning = "Kerberos pre-authentication failed" },
            @{ ID = 4776; Meaning = "NTLM authentication attempt" }
        )
    }
    "ADAccountChanges" = @{ 
        Log = "Security"; 
        IDs = @(
            @{ ID = 4720; Meaning = "User account created" },
            @{ ID = 4722; Meaning = "User account enabled" },
            @{ ID = 4723; Meaning = "Password change attempt" },
            @{ ID = 4724; Meaning = "Password reset attempt" },
            @{ ID = 4725; Meaning = "User account disabled" },
            @{ ID = 4726; Meaning = "User account deleted" },
            @{ ID = 4732; Meaning = "User added to security group" },
            @{ ID = 4735; Meaning = "Security group modified" },
            @{ ID = 4738; Meaning = "User account modified" },
            @{ ID = 4740; Meaning = "Account locked out" },
            @{ ID = 4756; Meaning = "Security group membership change" },
            @{ ID = 4767; Meaning = "Account unlocked" }
        )
    }
    "SecurityThreatIndicators" = @{ 
        Log = "Security"; 
        IDs = @(
            @{ ID = 1102; Meaning = "Audit log cleared" },
            @{ ID = 2886; Meaning = "LDAP unsigned/simple bind detected" },
            @{ ID = 2887; Meaning = "Count of unsigned/simple bind attempts" },
            @{ ID = 2889; Meaning = "Source of unsigned/simple bind" },
            @{ ID = 1644; Meaning = "Expensive LDAP query detected" },
            @{ ID = 4627; Meaning = "Group membership information" },
            @{ ID = 4663; Meaning = "Access to an object" }
        )
    }
    "ServerHealthReliability" = @{ 
        Log = "System"; 
        IDs = @(
            @{ ID = 41; Meaning = "Kernel-Power: unexpected restart/shutdown" },
            @{ ID = 55; Meaning = "NTFS file system corruption detected" },
            @{ ID = 6005; Meaning = "Event log service started" },
            @{ ID = 6006; Meaning = "Event log service stopped" },
            @{ ID = 6008; Meaning = "Unexpected shutdown" },
            @{ ID = 6009; Meaning = "System startup information" },
            @{ ID = 1074; Meaning = "System shutdown/restart initiated" },
            @{ ID = 1014; Meaning = "DNS name resolution failure" },
            @{ ID = 1058; Meaning = "Group Policy failure to read from DC" },
            @{ ID = 5719; Meaning = "Netlogon: no DC available" }
        )
    }
    "ApplicationLevelIssues" = @{ 
        Log = "Application"; 
        IDs = @(
            @{ ID = 1000; Meaning = "Application error (crash)" },
            @{ ID = 1001; Meaning = "Application hang or bugcheck info" },
            @{ ID = 1002; Meaning = "Application hang" },
            @{ ID = 1309; Meaning = "ASP.NET application error (IIS)" },
            @{ ID = 11707; Meaning = "Application installation" }
        )
    }
}

# XAML for UI
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Event ID Search" Height="600" Width="800">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="10">
            <RadioButton x:Name="rbAccountActivity" Content="Account Activity" GroupName="Category" IsChecked="True" Margin="5" ToolTip="Event IDs: 4624, 4625, 4634, 4647, 4648, 4672, 4768, 4769, 4771, 4776"/>
            <RadioButton x:Name="rbADAccountChanges" Content="AD Account Changes" GroupName="Category" Margin="5" ToolTip="Event IDs: 4720, 4722, 4723, 4724, 4725, 4726, 4732, 4735, 4738, 4740, 4756, 4767"/>
            <RadioButton x:Name="rbSecurityThreat" Content="Security Threat Indicators" GroupName="Category" Margin="5" ToolTip="Event IDs: 1102, 2886, 2887, 2889, 1644, 4627, 4663"/>
            <RadioButton x:Name="rbServerHealth" Content="Server Health and Reliability" GroupName="Category" Margin="5" ToolTip="Event IDs: 41, 55, 6005, 6006, 6008, 6009, 1074, 1014, 1058, 5719"/>
            <RadioButton x:Name="rbApplicationIssues" Content="Application-Level Issues" GroupName="Category" Margin="5" ToolTip="Event IDs: 1000, 1001, 1002, 1309, 11707"/>
        </StackPanel>
        <StackPanel Grid.Row="1" Orientation="Horizontal" Margin="10">
            <Label Content="Start Date:" Margin="5"/>
            <DatePicker x:Name="dpStart" Margin="5"/>
            <Label Content="End Date:" Margin="5"/>
            <DatePicker x:Name="dpEnd" Margin="5"/>
        </StackPanel>
        <StackPanel Grid.Row="2" Orientation="Horizontal" Margin="10">
            <Label Content="Filter by Event ID:" Margin="5"/>
            <ComboBox x:Name="cbEventID" Width="100" Margin="5"/>
        </StackPanel>
        <StackPanel Grid.Row="3" Orientation="Horizontal" Margin="10">
            <Button x:Name="btnClear" Content="Clear" Width="100" Height="30" Margin="5"/>
            <Button x:Name="btnSearch" Content="Search" Width="100" Height="30" Margin="5"/>
        </StackPanel>
        <DataGrid x:Name="dgResults" Grid.Row="4" AutoGenerateColumns="False" Margin="10">
            <DataGrid.Columns>
                <DataGridTextColumn Header="Time Created" Binding="{Binding TimeCreated}" Width="*"/>
                <DataGridTextColumn Header="Event ID" Binding="{Binding Id}" Width="Auto"/>
                <DataGridTextColumn Header="Meaning" Binding="{Binding Meaning}" Width="*"/>
                <DataGridTextColumn Header="Level" Binding="{Binding LevelDisplayName}" Width="Auto"/>
                <DataGridTextColumn Header="Message" Binding="{Binding Message}" Width="2*"/>
            </DataGrid.Columns>
        </DataGrid>
    </Grid>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Find controls
$rbAccountActivity = $window.FindName("rbAccountActivity")
$rbADAccountChanges = $window.FindName("rbADAccountChanges")
$rbSecurityThreat = $window.FindName("rbSecurityThreat")
$rbServerHealth = $window.FindName("rbServerHealth")
$rbApplicationIssues = $window.FindName("rbApplicationIssues")
$dpStart = $window.FindName("dpStart")
$dpEnd = $window.FindName("dpEnd")
$cbEventID = $window.FindName("cbEventID")
$btnSearch = $window.FindName("btnSearch")
$btnClear = $window.FindName("btnClear")
$dgResults = $window.FindName("dgResults")

# Set default dates
$dpStart.SelectedDate = (Get-Date).AddDays(-3)
$dpEnd.SelectedDate = Get-Date

# Function to update ComboBox with Event IDs based on selected category
function Update-EventIDComboBox {
    $selectedCategory = ""
    if ($rbAccountActivity.IsChecked) { $selectedCategory = "AccountActivity" }
    elseif ($rbADAccountChanges.IsChecked) { $selectedCategory = "ADAccountChanges" }
    elseif ($rbSecurityThreat.IsChecked) { $selectedCategory = "SecurityThreatIndicators" }
    elseif ($rbServerHealth.IsChecked) { $selectedCategory = "ServerHealthReliability" }
    elseif ($rbApplicationIssues.IsChecked) { $selectedCategory = "ApplicationLevelIssues" }

    if ($selectedCategory -ne "") {
        $cbEventID.Items.Clear()
        $cbEventID.Items.Add("(All)") | Out-Null
        $categories[$selectedCategory].IDs | ForEach-Object {
            $cbEventID.Items.Add("$($_.ID) - $($_.Meaning)") | Out-Null
        }
        $cbEventID.SelectedIndex = 0
    }
}

# Attach event handlers to radio buttons to update ComboBox
$rbAccountActivity.Add_Checked({ Update-EventIDComboBox })
$rbADAccountChanges.Add_Checked({ Update-EventIDComboBox })
$rbSecurityThreat.Add_Checked({ Update-EventIDComboBox })
$rbServerHealth.Add_Checked({ Update-EventIDComboBox })
$rbApplicationIssues.Add_Checked({ Update-EventIDComboBox })

# Initialize ComboBox with default category (AccountActivity)
Update-EventIDComboBox

# Clear button click event
$btnClear.Add_Click({
    $dgResults.ItemsSource = $null
})

# Search button click event
$btnSearch.Add_Click({
    $selectedCategory = ""
    if ($rbAccountActivity.IsChecked) { $selectedCategory = "AccountActivity" }
    elseif ($rbADAccountChanges.IsChecked) { $selectedCategory = "ADAccountChanges" }
    elseif ($rbSecurityThreat.IsChecked) { $selectedCategory = "SecurityThreatIndicators" }
    elseif ($rbServerHealth.IsChecked) { $selectedCategory = "ServerHealthReliability" }
    elseif ($rbApplicationIssues.IsChecked) { $selectedCategory = "ApplicationLevelIssues" }

    if ($selectedCategory -ne "") {
        $cat = $categories[$selectedCategory]
        $start = $dpStart.SelectedDate
        $end = $dpEnd.SelectedDate.AddDays(1)  # Include end day

        # Determine Event IDs to filter
        $eventIDs = if ($cbEventID.SelectedItem -eq "(All)") {
            $cat.IDs.ID
        } else {
            $selectedID = $cbEventID.SelectedItem -split " - " | Select-Object -First 1
            @([int]$selectedID)
        }

        $filter = @{
            LogName = $cat.Log
            ID = $eventIDs
            StartTime = $start
            EndTime = $end
        }

        try {
            $events = Get-WinEvent -FilterHashtable $filter -ErrorAction Stop
            $eventData = $events | ForEach-Object {
                $id = $_.Id
                $meaning = ($cat.IDs | Where-Object { $_.ID -eq $id }).Meaning
                [PSCustomObject]@{
                    TimeCreated = $_.TimeCreated
                    Id = $id
                    Meaning = $meaning
                    LevelDisplayName = $_.LevelDisplayName
                    Message = $_.Message
                }
            }
            $dgResults.ItemsSource = $eventData
        } catch {
            [System.Windows.MessageBox]::Show("Error retrieving events: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    }
})

# Show window
$window.ShowDialog() | Out-Null
