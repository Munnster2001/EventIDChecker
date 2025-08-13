# Event ID Search Tool

## Overview
This PowerShell script creates a WPF-based GUI application for searching and displaying Windows Event Logs based on predefined categories and Event IDs. It allows users to filter events by category, date range, and specific Event IDs, with results displayed in a DataGrid.

## Features
- **Categories**: Five categories of events:
  - **Account Activity**: Authentication events (e.g., logon, logoff).
  - **AD Account Changes**: Active Directory account modifications.
  - **Security Threat Indicators**: Potential security risks (e.g., audit log clearing).
  - **Server Health and Reliability**: System stability events (e.g., shutdowns, service status).
  - **Application-Level Issues**: Application errors and installations.
- **Event ID Filter**: ComboBox to filter by specific Event IDs within a category.
- **Date Range**: Select start and end dates for event filtering.
- **ToolTips**: Mouse-over ToolTips on radio buttons show associated Event IDs.
- **DataGrid**: Displays Time Created, Event ID, Meaning, Level, and Message.
- **Clear Button**: Clears the DataGrid results.
- **Search Button**: Queries event logs based on selected filters.

## Requirements
- PowerShell 5.1 or later with WPF support.
- Administrative privileges for accessing logs like `Security`.
- Auditing policies enabled for specific events (e.g., Object Access, Account Management).

## Usage
1. Run the script in PowerShell with administrative privileges.
2. Select a category using radio buttons.
3. Choose a date range using DatePickers (defaults to last 3 days to today).
4. Optionally filter by a specific Event ID using the ComboBox (or select "(All)").
5. Click **Search** to retrieve events, displayed in the DataGrid.
6. Click **Clear** to reset the DataGrid.

## Notes
- **Log Availability**: Some Event IDs (e.g., 2886–2889) require specific auditing configurations (e.g., LDAP auditing).
- **Security Threat Indicators**: Uses the `Security` log; adjust to `Directory Service` if needed for specific environments.
- **Testing**: Verify Event IDs are logged in your environment, as some depend on system configuration.

## Event IDs and Meanings
- **Account Activity**: 4624 (Successful logon), 4625 (Failed logon attempt), 4634 (Logoff), 4647 (User-initiated logoff), 4648 (Explicit credentials used), 4672 (Security ID assigned), 4768 (Kerberos TGT request), 4769 (Kerberos service ticket request), 4771 (Kerberos pre-authentication failed), 4776 (NTLM authentication).
- **AD Account Changes**: 4720 (User account created), 4722 (User account enabled), 4723 (Password change attempt), 4724 (Password reset attempt), 4725 (User account disabled), 4726 (User account deleted), 4732 (User added to security group), 4735 (Security group modified), 4738 (User account modified), 4740 (Account locked out), 4756 (Security group membership change), 4767 (Account unlocked).
- **Security Threat Indicators**: 1102 (Audit log cleared), 2886 (LDAP unsigned/simple bind detected), 2887 (Count of unsigned/simple binds), 2889 (Source of unsigned/simple bind), 1644 (Expensive LDAP query), 4627 (Group membership information), 4663 (Access to an object).
- **Server Health and Reliability**: 41 (Kernel-Power: unexpected restart/shutdown), 55 (NTFS corruption), 6005 (Event log service started), 6006 (Event log service stopped), 6008 (Unexpected shutdown), 6009 (System startup information), 1074 (System shutdown/restart initiated), 1014 (DNS resolution failure), 1058 (Group Policy failure), 5719 (Netlogon: no DC available).
- **Application-Level Issues**: 1000 (Application error), 1001 (Application hang/bugcheck info), 1002 (Application hang), 1309 (ASP.NET error), 11707 (Application installation).
