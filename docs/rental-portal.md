---
tags:
  - Rental Portal
  - GPU Nodes
  - Maintenance Fee
  - Cost Allocation
  - Invoice
  - API
---

# ORCD Rental Portal

The ORCD Rental Portal provides a web-based interface for managing GPU node rentals, account maintenance fees, and project billing. This guide covers all aspects of using the portal, from basic account setup to advanced management features.

**Portal Access:** [https://orcd-rental.mit.edu](https://orcd-rental.mit.edu)

## Overview

The Rental Portal is built around **projects**. Each user can belong to multiple projects, and each project can have multiple members with different roles. To rent GPU nodes, your project must have an approved cost allocation that specifies how charges will be billed.

Key concepts:

- **Projects** organize users and billing for rentals
- **Roles** determine what actions you can take within a project
- **Cost Allocations** define how rental charges are billed
- **Reservations** are requests to rent GPU nodes for specific time periods

---

## Getting Started

### Accessing the Portal

Log into the ORCD Rental Portal using your MIT Kerberos credentials at [https://orcd-rental.mit.edu](https://orcd-rental.mit.edu). After logging in, you'll see the main navigation with links to:

- **Home** - Dashboard with summary cards for your rentals, projects, account, and billing
- **Nodes** - View available GPU and CPU node information
- **Rent H200x8** - Access the rental calendar and make reservations
- **Projects** - View and manage your projects
- **User Profile** - View your account information and maintenance fee status

### Dashboard Overview

After logging in, you'll see your personalized dashboard with four summary cards:

| Card | What It Shows |
|------|---------------|
| **My Rentals** | Upcoming, pending, and past reservation counts; your next 3 reservations |
| **My Projects** | Projects you own vs. projects where you're a member; quick links to recent projects |
| **My Account** | Your maintenance fee status and billing project |
| **My Billing** | Cost allocation approval status for your projects; projects needing attention |

Each card includes a help icon (?) that provides additional context when clicked.

### Your Projects

When your account is created, you automatically receive two projects:

- **`username_personal`** - Your personal project for individual use
- **`username_group`** - A group project you can use to collaborate with others

You can also be added as a member to other users' projects with various roles.

### Project Roles

Each project member has one or more roles that determine their permissions. Users can hold multiple roles simultaneously, and permissions are cumulative.

| Role | Description |
|------|-------------|
| **Owner** | Full control over the project. Can manage all members, cost allocations, and settings. Automatically included in reservations. |
| **Financial Admin** | Can edit cost allocations and manage all member roles. *Not* included in reservations or maintenance fee billing. |
| **Technical Admin** | Can add members and other technical admins. Included in reservations and can use the project for maintenance fees. |
| **Member** | Can create reservations. Included in reservations and can use the project for maintenance fees. |

!!! note "Multi-Role Support"
    A user can have multiple roles on the same project. For example, someone with both Financial Admin and Technical Admin roles can edit cost allocations *and* be included in reservations.

### Role Permissions Summary

**Cost Allocation Management:**

- Owner: Yes
- Financial Admin: Yes
- Technical Admin: No
- Member: No

**Manage Financial Admins:**

- Owner: Yes
- Financial Admin: Yes
- Technical Admin: No
- Member: No

**Manage Technical Admins and Members:**

- Owner: Yes
- Financial Admin: Yes
- Technical Admin: Yes
- Member: No

**Create Reservations:**

- Owner: Yes
- Financial Admin: Yes
- Technical Admin: Yes
- Member: Yes

**Included in Reservations:**

- Owner: Yes
- Financial Admin: No
- Technical Admin: Yes
- Member: Yes

**Use Project for Maintenance Fee:**

- Owner: Yes
- Financial Admin: No
- Technical Admin: Yes
- Member: Yes

---

## Account Maintenance Fee

The account maintenance fee is a recurring charge for access to ORCD shared computing resources. You can set your maintenance fee status from your User Profile.

### Maintenance Fee Levels

| Status | Description |
|--------|-------------|
| **Inactive** | No maintenance fee charged. Limited access to shared resources. |
| **Basic** | Standard maintenance fee. Access to shared computing resources. |
| **Advanced** | Higher maintenance fee. Access to additional resources and priority support. |

### Setting Your Maintenance Fee Status

1. Click on your username in the top navigation bar
2. Select **User Profile**
3. Find the **Account Maintenance Fee Status** row
4. Click the edit icon (pencil) next to your current status
5. Select your desired status level (Inactive, Basic, or Advanced)
6. If selecting Basic or Advanced, choose a **Billing Project** from the dropdown
7. Click **Save**

!!! warning "Billing Project Requirements"
    To use a project for maintenance fee billing:
    
    1. You must have an eligible role on the project: **Owner**, **Technical Admin**, or **Member** (Financial Admins cannot use a project for their own maintenance fee billing)
    2. The project must have an **approved cost allocation**
    
    Only projects meeting both requirements appear in the billing project dropdown. If no eligible projects are available, a warning message will be displayed.

### What Happens When Roles Change

If your role on your billing project changes to one that is not eligible (e.g., you become only a Financial Admin, or are removed from the project entirely), your maintenance fee status will automatically reset to **Inactive**. You will need to select a new billing project or update your role to restore your maintenance fee status.

??? example "Example Scenario: Setting Up Maintenance Fee"
    *Dr. Smith is a new researcher who needs basic access to ORCD systems. She logs into the portal, navigates to her User Profile, and clicks the edit icon next to "Account Maintenance Fee Status." She selects "Basic" from the dropdown, then chooses her `smith_personal` project as the billing project. After clicking Save, her status updates to "Basic (charged to: smith_personal)". Her department's cost object associated with that project will be charged the monthly fee.*

---

## GPU Node Rentals

The Rental Portal allows you to reserve dedicated H200x8 GPU nodes for your research projects. Reservations require a project with an approved cost allocation.

### Prerequisites

Before making a reservation, ensure:

1. You are a member of a project with an **approved cost allocation**
2. You have an appropriate role (Owner, Financial Admin, Technical Admin, or Member)

!!! tip "Check Your Project Status"
    Visit your project's detail page to verify the cost allocation status. Look for the green "Approved" badge in the Cost Allocation section.

### Viewing the Rental Calendar

Navigate to **Rent H200x8** in the main menu to access the rental calendar. The calendar displays availability for all rentable H200x8 nodes.

**Calendar Color Legend:**

| Color | Meaning |
|-------|---------|
| Gray | Not available for booking (too soon or outside booking window) |
| Green | Available for reservation |
| Red | Already rented |
| Split (diagonal) | Partially rented (AM or PM only) |
| "P" badge | Pending reservation request |
| User icon | Your rental |

**Calendar Navigation:**

- The calendar shows availability starting from today
- Use the Previous/Next buttons to navigate between months
- You can view up to 3 months ahead

### Making a Reservation Request

1. From the rental calendar, click **Request Reservation**
2. Fill in the reservation details:
   - **GPU Node**: Select the specific H200x8 node you want to reserve
   - **Project**: Choose the project this reservation is for (must have approved cost allocation)
   - **Start Date**: Select when your reservation should begin
   - **Duration**: Choose the number of 12-hour blocks
   - **Notes** (optional): Add any relevant information about your reservation
3. Click **Submit Request**

### Reservation Timing Rules

| Rule | Details |
|------|---------|
| **Start Time** | All reservations start at **4:00 PM** on the start date |
| **Duration** | Measured in 12-hour blocks (minimum: 1 block = 12 hours) |
| **End Time** | Reservations must end no later than **9:00 AM** on the final day |
| **Advance Booking** | Reservations must be made at least **7 days in advance** |
| **Maximum Lookahead** | Calendar shows availability up to **3 months ahead** |

### Tracking Your Reservations

Your reservations appear on the calendar with a user icon overlay. Pending reservations show a "P" badge until approved by a Rental Manager.

### My Reservations Page

For a comprehensive view of all your reservations across all projects, visit the **My Reservations** page at `/nodes/my/reservations/`. This page shows reservations from every project where you have a role.

**Summary Cards:**

The page displays summary cards showing counts for each category:

- **Upcoming**: Approved reservations that haven't started yet
- **Pending**: Reservation requests awaiting approval
- **Past**: Completed reservations
- **Declined/Cancelled**: Requests that were declined or cancelled

**Reservation Details:**

Each reservation shows:

- The project name and your role(s) on that project
- Node, dates, and duration
- Current status (Approved, Pending, Declined, Cancelled)

Use the tabs to filter between categories.

### After Submission

After submitting a reservation request:

1. Your request enters **Pending** status
2. A Rental Manager reviews the request
3. You will be notified when your request is **Approved** or **Declined**
4. If declined, the Rental Manager may include notes explaining why

??? example "Example Scenario: Making a Reservation"
    *Dr. Johnson's lab needs exclusive access to a GPU node for a 3-day training run. She navigates to the Rent H200x8 page and checks the calendar. She sees node `orcd2304` is available next week (shown in green). She clicks "Request Reservation", selects the node, chooses her `johnson_lab` project, picks Monday as the start date, and selects 6 blocks (72 hours) for the duration. She adds a note: "Large language model fine-tuning run." After submitting, the reservation shows as "P" (pending) on the calendar. Two days later, she receives notification that the Rental Manager has approved her request.*

---

## Setting Up Project Cost Allocations

Before your project can be used for GPU node rentals, you must configure a cost allocation that specifies how charges will be billed. Only **Owners** and **Financial Admins** can manage cost allocations.

### Why Cost Allocations Are Required

Cost allocations link your project to one or more cost objects (billing accounts). When you rent GPU nodes, the rental charges are distributed across these cost objects according to the percentages you specify. Projects without an approved cost allocation cannot make reservations.

### Navigating to Cost Allocation

1. Go to **Projects** in the main navigation
2. Click on your project name to view project details
3. Click **Manage Cost Allocation** in the Cost Allocation section

### Adding Cost Objects

On the Cost Allocation page:

1. Enter a **Cost Object** identifier in the text field
   - Format: Letters, numbers, and hyphens only (e.g., `GRANT-2024-12345`, `DOE-AI-789`)
2. Enter the **Percentage** of charges to allocate to this cost object
3. Click **Add Cost Object** to add additional cost objects if needed
4. Optionally add **Allocation Notes** to describe the billing arrangement

!!! warning "Percentage Total"
    All percentages must sum to exactly **100%**. The form displays a running total and indicates whether your allocation is valid.

### Submitting for Approval

1. Review your cost objects and percentages
2. Click **Save Cost Allocation**
3. Your allocation status changes to **Pending Approval**

A Billing Manager will review your submission and either approve or reject it.

### Understanding Approval Status

| Status | Badge Color | Meaning |
|--------|-------------|---------|
| **Pending** | Yellow | Awaiting review by a Billing Manager |
| **Approved** | Green | Cost allocation is active; project can make reservations |
| **Rejected** | Red | Cost allocation was rejected; see notes for reason |

### If Your Allocation Is Rejected

1. Check the project detail page for the rejection reason in the Cost Allocation section
2. Navigate to **Manage Cost Allocation**
3. Correct the issues (e.g., update invalid cost object, fix percentages)
4. Save to resubmit for approval

!!! note "Resubmission"
    Any changes to an approved cost allocation will reset the status to Pending and require re-approval.

### Managing Project Members

From your project's detail page, you can manage team members:

1. Click **Manage Members** to view all project members and their roles
2. Click **Add Member** to invite new users to the project
3. Use the edit button next to a member to update their roles
4. Use the remove button to remove a member from the project

**Removing Members:**

When removing a member, a confirmation dialog appears where you can optionally add notes explaining the reason for removal. These notes are recorded for audit purposes.

!!! note "Owner Protection"
    The project owner cannot be removed from the project. To change ownership, contact ORCD support.

??? example "Example Scenario: Setting Up Cost Allocation"
    *Dr. Martinez wants her lab to start renting GPU nodes for machine learning research. She navigates to her `martinez_lab` project and clicks "Manage Cost Allocation." She enters her grant's cost object `DOE-AI-2024-789` and sets it to 100%. She adds a note: "DOE AI Research Grant - expires Dec 2025." After clicking Save, the status shows "Pending Approval" with a yellow badge. Three days later, a Billing Manager reviews and approves the allocation. The badge turns green, and Dr. Martinez's team can now start making GPU node reservations.*

---

## Rental Manager Guide

This section is for staff members with the **Rental Manager** role who are responsible for reviewing and processing GPU node reservation requests.

### Accessing the Rental Manager Dashboard

1. Log into the Rental Portal
2. Click **Manage Rentals** in the navigation bar (visible only to Rental Managers)
3. You'll see the Rental Manager Dashboard with pending and recent reservations

### Reviewing Pending Requests

The dashboard displays all pending reservation requests in a table showing:

- **Node**: The requested GPU node
- **Project**: The project making the request
- **Requester**: The user who submitted the request
- **Start/End**: Reservation dates and times
- **Duration**: Total billable hours
- **Notes**: Any notes from the requester
- **Submitted**: When the request was made

### Approving Reservations

To approve a reservation:

1. Review the request details
2. Click the green **Approve** button
3. The reservation is immediately confirmed and the calendar updates

### Declining Reservations

To decline a reservation:

1. Click the red **Decline** button
2. In the modal that appears, optionally enter notes explaining the reason
3. Click **Decline Reservation**
4. The requester will see your notes when viewing the declined request

!!! tip "Provide Clear Feedback"
    When declining a request, include helpful notes so the requester understands why and can resubmit if appropriate. For example: "Declined due to scheduled maintenance on this date. Please select an alternate date."

### Adding Management Metadata

You can add internal notes to any reservation for tracking purposes:

1. Click the gear icon next to a reservation
2. View any existing metadata entries (timestamped)
3. Add new entries in the text area
4. Click **Save New Entries**

!!! note "Metadata Visibility"
    Management metadata is only visible to Rental Managers, not to the requester.

### Viewing Recent Reservations

The dashboard also shows reservations processed in the last 30 days, including their approval status. You can add metadata to these reservations as well.

??? example "Example Scenario: Processing Requests"
    *Sarah, a Rental Manager, logs in and sees 3 pending reservation requests on her dashboard. She reviews each one:*
    
    *1. A routine 24-hour request from the Chen Lab - she clicks Approve.*
    
    *2. A week-long request from the Johnson Lab - she verifies the dates don't conflict with maintenance, then clicks Approve.*
    
    *3. A request for next Tuesday, which is a scheduled maintenance day - she clicks Decline and adds the note: "Declined: Tuesday March 18 is a scheduled maintenance day. Please select an alternate start date." She then clicks the gear icon and adds internal metadata: "User notified via email about maintenance schedule."*

---

## Billing Manager Guide

This section is for staff members with the **Billing Manager** role who are responsible for reviewing cost allocations and preparing invoice reports.

The Billing Manager interface has two tabs:

- **Pending Cost Allocations** - Review and approve/reject cost allocation submissions
- **Invoice Reporting** - Generate, review, and export monthly billing reports

### Pending Cost Allocations

#### Accessing Pending Cost Allocations

1. Log into the Rental Portal
2. Click **Manage Billing** in the navigation bar (visible only to Billing Managers)
3. The **Pending Cost Allocations** tab shows all pending submissions

#### Reviewing Submissions

The pending allocations page displays:

- **Project**: The project name (click to view project details)
- **Owner**: The project owner's username and name
- **Cost Objects**: The submitted cost objects and their percentages
- **Submitted**: When the allocation was submitted or last modified

Click **Review** to open the detailed review page for a submission.

#### Verifying Cost Objects

Before approving, verify that:

1. The cost object identifiers are valid in the financial system
2. The percentages sum to 100%
3. The cost objects are appropriate for the project and not expired

#### Approving Allocations

To approve a cost allocation:

1. Review the cost objects and percentages
2. Optionally add review notes
3. Click **Approve**
4. The project can now be used for GPU node reservations

#### Rejecting Allocations

To reject a cost allocation:

1. Enter notes explaining why the allocation was rejected
2. Click **Reject**
3. The project owner/financial admin will see your notes and can correct and resubmit

!!! warning "Rejection Notes Are Important"
    Always include clear notes when rejecting an allocation so the submitter knows what to fix. For example: "Cost object ABC-123 has expired as of January 2025. Please use a current account."

#### Impact on Reservations

- Projects with **Pending** cost allocations cannot create new reservations
- Projects with **Rejected** cost allocations cannot create new reservations
- Only projects with **Approved** cost allocations can make reservations

??? example "Example Scenario: Reviewing Cost Allocations"
    *Mike, a Billing Manager, logs into the portal and navigates to Manage Billing. He sees 5 pending cost allocation requests. He clicks Review on each one:*
    
    *1-4. Four allocations have valid, active cost objects - he approves each one.*
    
    *5. One allocation lists cost object `ABC-123` which Mike knows expired last month. He enters the note: "Cost object ABC-123 has expired. Please use a current account number." and clicks Reject.*
    
    *The project owner receives notification and updates their cost allocation with a valid cost object, resubmitting for approval.*

### Invoice Reporting

The Invoice Reporting feature allows Billing Managers to generate, review, and export monthly billing reports for GPU node rentals.

#### Accessing Invoice Reporting

1. Navigate to **Manage Billing** in the navigation bar
2. Click the **Invoice Reporting** tab

#### Viewing Available Months

The Invoice Reporting page lists all months with completed reservations. For each month, you can see:

- **Month/Year**: The billing period
- **Status**: Draft (editable) or Finalized (locked)
- **Overrides**: Number of manual adjustments applied
- **Actions**: Click **View Report** to see the detailed invoice

#### Understanding Invoice Status

| Status | Icon | Meaning |
|--------|------|---------|
| **Draft** | Yellow badge | Invoice can be edited; overrides can be added or removed |
| **Finalized** | Green badge with lock | Invoice is locked; no further edits allowed |

#### Invoice Report Details

Each monthly invoice report shows reservations grouped by project:

- **Project summary**: Project name, owner, and total hours for the month
- **Per-reservation details**:
  - Reservation ID and node
  - Date range
  - Hours within the billing month
  - Cost object breakdown (hours distributed by percentage)
  - Override status (if any)

!!! note "Cost Allocation Snapshots"
    When a cost allocation is approved, the system creates a snapshot of the cost objects and percentages. This ensures billing accuracy even if the cost allocation is later modified. Invoice reports use the snapshot that was active during each reservation period.

#### Filtering Invoice Entries

For invoices with many projects, you can filter the displayed entries:

- **Owner Filter**: Use the dropdown to show only projects owned by a specific user
- **Title Filter**: Enter a text pattern to show only projects whose titles contain that text

Both filters can be used together. The filters apply only to the current view and do not affect the exported data.

#### Creating Overrides

Sometimes you need to adjust billing for specific reservations. Click the **Edit** button next to any reservation to create an override.

**Override Types:**

| Type | Description |
|------|-------------|
| **Exclude from Invoice** | Remove the reservation from billing entirely |
| **Override Hours** | Adjust the billable hours for this reservation |
| **Override Cost Split** | Redistribute hours across cost objects differently than the default percentages |

!!! warning "Notes Are Required"
    All overrides require a note explaining the reason. This creates an audit trail for billing adjustments.

To delete an override, click the **X** button next to the override badge on the invoice report.

#### Finalizing Invoices

Once you have reviewed all reservations and made any necessary adjustments:

1. Click **Finalize Invoice**
2. Confirm the action
3. The invoice is locked from further edits

The finalized invoice shows who finalized it and when, providing a complete audit trail.

#### Reopening Finalized Invoices

If corrections are needed after finalization:

1. Click **Reopen for Editing**
2. Confirm the action
3. The invoice returns to Draft status

#### Exporting JSON Reports

To export an invoice for external systems or record-keeping:

1. Click **Export JSON** on the invoice report page
2. The browser downloads a JSON file containing:
   - All reservations with start/end datetimes
   - Cost object breakdowns
   - Override details and notes
   - Audit metadata (finalization status, reviewer info)

??? example "Example Scenario: Preparing Monthly Invoice"
    *Lisa, a Billing Manager, needs to prepare the December invoice. She navigates to the Invoice Reporting tab and clicks "View Report" for December 2025. She reviews the report showing 15 reservations across 8 projects.*
    
    *One reservation was for testing and shouldn't be billed - she clicks the edit button, selects "Exclude from Invoice", adds the note "Test reservation - do not bill per PI request", and saves.*
    
    *Another reservation needs adjusted hours due to a system outage - she creates an "Override Hours" entry, reduces the hours from 72 to 60, and notes "12 hours credited due to network outage on Dec 15."*
    
    *After reviewing all entries, she clicks "Finalize Invoice" to lock it from further changes. She then clicks "Export JSON" to download the report for the accounting system.*

---

## Activity Log

The Activity Log provides an audit trail of significant actions in the Rental Portal. This feature is available to **Rental Managers**, **Billing Managers**, and system administrators.

### Accessing the Activity Log

1. Log into the Rental Portal with a manager account
2. Navigate to **Admin Functions** in the navigation bar
3. Click **Activity Log**

### Activity Categories

The activity log tracks events across multiple categories:

| Category | Events Tracked |
|----------|----------------|
| **Authentication** | User logins, logouts, and failed login attempts |
| **Reservation** | Reservation creation, approval, decline, and cancellation |
| **Member** | Role additions, role removals, and member removals from projects |
| **Cost Allocation** | Cost allocation submissions and approval status changes |
| **Invoice** | Invoice finalization, reopening, and override changes |
| **Maintenance** | Maintenance fee status changes |
| **API** | API access events |

### Filtering the Log

Use the filter options to narrow down the activity log:

- **Category**: Filter by event type (e.g., only show reservation events)
- **User**: Filter by the user who performed the action
- **Date range**: Filter by when events occurred

### Understanding Log Entries

Each log entry shows:

- **Timestamp**: When the action occurred
- **User**: Who performed the action
- **Category**: Type of event
- **Description**: What happened
- **Details**: Additional context (e.g., project name, reservation ID)

!!! note "Manager Access"
    The Activity Log is only visible to Rental Managers and Billing Managers. Regular users do not have access to this feature.

---

## REST API

The Rental Portal provides a REST API for programmatic access to rental and invoice data.

### Authentication

API access requires token authentication. Include your token in the `Authorization` header of all requests:

```
Authorization: Token your-token-here
```

#### For Users: Getting Your Token

1. Log into the Rental Portal
2. Navigate to **User Profile**
3. Your API token is displayed in the profile section
4. Click **Regenerate Token** if you need a new token (this invalidates the old one)

#### For Administrators: Creating Tokens via Command Line

Administrators can create or regenerate tokens for any user using the Django management command:

```bash
export PLUGIN_API=True
python manage.py drf_create_token -r USERNAME
```

- Use `-r` to regenerate an existing token (replaces the old token)
- Without `-r`, creates a new token only if the user doesn't already have one
- The command outputs the token key

!!! warning "Token Security"
    Treat API tokens like passwords. Do not share them or commit them to version control. If a token is compromised, regenerate it immediately.

### Available Endpoints

| Endpoint | Method | Permission Required | Description |
|----------|--------|---------------------|-------------|
| `/nodes/api/rentals/` | GET | `can_manage_rentals` | List and filter reservations |
| `/nodes/api/users/search/?q=` | GET | Authenticated | Search users by username, name, or email |
| `/nodes/api/invoice/` | GET | `can_manage_billing` | List months with invoice data |
| `/nodes/api/invoice/YYYY/MM/` | GET | `can_manage_billing` | Get full invoice report for a specific month |
| `/nodes/api/activity-log/` | GET | `can_manage_rentals` or `can_manage_billing` | Query the activity log |

### CLI Examples

**List available invoice months:**

```bash
curl -H "Authorization: Token your-token-here" \
     https://orcd-rental.mit.edu/nodes/api/invoice/
```

**Download invoice for a specific month:**

```bash
curl -H "Authorization: Token your-token-here" \
     https://orcd-rental.mit.edu/nodes/api/invoice/2025/12/ \
     -o december-2025-invoice.json
```

**Search for users:**

```bash
curl -H "Authorization: Token your-token-here" \
     "https://orcd-rental.mit.edu/nodes/api/users/search/?q=smith"
```

??? example "Example Scenario: Automated Invoice Retrieval"
    *A department administrator wants to automate monthly invoice retrieval for their accounting system. They get their API token from the User Profile page, then create a script that runs on the first of each month:*
    
    ```bash
    #!/bin/bash
    TOKEN="abc123..."
    YEAR=$(date -d "last month" +%Y)
    MONTH=$(date -d "last month" +%m)
    
    curl -H "Authorization: Token $TOKEN" \
         "https://orcd-rental.mit.edu/nodes/api/invoice/${YEAR}/${MONTH}/" \
         -o "invoice-${YEAR}-${MONTH}.json"
    ```
    
    *The JSON file is then processed by their accounting software to generate internal billing records.*

---

## Quick Reference

### Reservation Time Rules

- **Start Time**: 4:00 PM on start date
- **Duration**: 12-hour blocks (12, 24, 36, ... hours)
- **End Time Cap**: 9:00 AM maximum on final day
- **Advance Booking**: Minimum 7 days ahead
- **Calendar Visibility**: Up to 3 months ahead

### Key Portal URLs

| Page | Path | Access |
|------|------|--------|
| Home Dashboard | `/` | All users |
| Rental Calendar | `/nodes/renting/` | All users |
| Request Reservation | `/nodes/renting/request/` | All users |
| My Reservations | `/nodes/my/reservations/` | All users |
| User Profile | `/user/user-profile/` | All users |
| Project List | `/project/` | All users |
| Rental Manager Dashboard | `/nodes/renting/manage/` | Rental Manager |
| Activity Log | `/nodes/activity-log/` | Rental/Billing Manager |
| Billing Manager - Pending Allocations | `/nodes/billing/pending/` | Billing Manager |
| Billing Manager - Invoice Reporting | `/nodes/billing/invoice/` | Billing Manager |
| Invoice Report (specific month) | `/nodes/billing/invoice/YYYY/MM/` (supports `?owner=` and `?title=` filters) | Billing Manager |
| Invoice Edit Override | `/nodes/billing/invoice/YYYY/MM/edit/` | Billing Manager |
| Invoice Export JSON | `/nodes/billing/invoice/YYYY/MM/export/` | Billing Manager |

### API Endpoints

| Endpoint | Path | Access |
|----------|------|--------|
| Reservations API | `/nodes/api/rentals/` | Rental Manager |
| User Search API | `/nodes/api/users/search/` | All users |
| Invoice List API | `/nodes/api/invoice/` | Billing Manager |
| Invoice Report API | `/nodes/api/invoice/YYYY/MM/` | Billing Manager |
| Activity Log API | `/nodes/api/activity-log/` | Rental/Billing Manager |

### Role Quick Reference

**Who can edit cost allocations?**
Owner, Financial Admin

**Who can manage project members?**
Owner, Financial Admin, Technical Admin

**Who is included in reservations?**
Owner, Technical Admin, Member (NOT Financial Admin)

**Who can use a project for maintenance fee billing?**
Owner, Technical Admin, Member (NOT Financial Admin)

### Getting Help

For questions or issues with the Rental Portal, contact us:

- **Email**: [orcd-help@mit.edu](mailto:orcd-help@mit.edu)
- **Documentation**: [https://orcd-docs.mit.edu](https://orcd-docs.mit.edu)


