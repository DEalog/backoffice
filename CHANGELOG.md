## Unreleased

- `ADD` Users are anonymously tracked to get some metrics
- `ADD` User accounts can be changed
- `ADD` Users can be onboarded with an account containing the personal data as well as the organizational settings
- `ADD` Users are listed in the settings area
- `CNG` Frontend dependecies are updated
- `FIX` Login with unconfirmed users issues is handled by emitting a user or password wrong message
- `FIX` The Kafka configuration is read correctly when no projectors are configured
- `ADD` Setup GH Actions to deploy application to AWS
- `CNG` Send ARS instead of a geocode to Kafka
- `CNG` Structure of administrative areas is changed to ARS (from AGS)
- `ADD` Mail support for registration, password reset, email change is available
- `CNG` Update dependencies
- `ADD` Authentication is implemented for all content pages
- `ADD` Users can change their email address
- `ADD` Users can change their password
- `ADD` Users can authenticate
- `ADD` Users can register

## 0.4.0

This release covers message publishing for a single organization.

- `ADD` Forms have cancel buttons
- `CNG` Deployments are update to use the new default branch `main`
- `CNG` Adapt dev script for new default branch `main`
- `CNG` Import of administrative areas is running on container start (until there is support for one-off tasks)
- `ADD` Administrative areas can be imported
- `FIX` The Kafka host can be configured via an env var
- `ADD` Published message details can be viewed
- `ADD` Published messages are shown in the all messages list
- `ADD` Preview deployment cleanup supports custom branches
- `ADD` Published messages get distributed to Kafka if enabled
- `ADD` Messages that are approved can be published
- `CNG` Projection reset script can be run in prod as well (with a security flag)
- `FIX` Tag name for master build
- `FIX` Fix GH Action output for deployment
- `ADD` Manual preview deployments are available
- `ADD` A health endpoint is added for monitoring
- `ADD` Application can be deployed via mix release on Docker
- `CNG` Rejected messages are removed from the approval section
- `CNG` Improve message listings
- `ADD` Messages can be deleted

## 0.3.0

This release has a basic approval process for a single organization on board.

- `CNG` Redirects of actions on message refer to the detail view of that message
- `ADD` Approved messages can have a note attached to them
- `ADD` Messages waiting for approval can be approved
- `ADD` Message details can be viewed for approvals
- `ADD` Message details can be viewed for my organization
- `ADD` Rejected messages can have a reason
- `ADD` Messages waiting for approval can be rejected
- `ADD` Dev script has a task to reset the task database
- `ADD` Messages waiting for approval are listed in the approvals section
- `ADD` Messages can be sent for approval
- `ADD` Error messages are displayed as notification
- `CNG` No change saves do not emit a changed event
- `ADD` Favicons are added
- `CNG` Improve my organization table layout

## 0.2.0

This release contains adding and changing new messages for a single organization.

- `NEW` Database is setup and provisioned on deployment
- `NEW` Projections can be reset more easily
- `CNG` Mix tasks can be ran independently of "stack" container
- `NEW` Messages can be changed
- `NEW` Dev script supports spawning an IEx session
- `NEW` Dev script supports running arbitrary mix commands
- `NEW` Dismissible and auto hiding UI notifications to provide feedback are added
- `NEW` New messages are listed in the organization section
- `NEW` New messages can be created
- `NEW` Event store is available to record all events within the application

## 0.1.0

This is the initial version setting up the base system with the page structure and initial design.

- `NEW` Design system is available
- `CNG` Footer renders better on mobile
- `FIX` Mobile / profile navigation closes properly now
- `CNG` Change link generation in footer
- `NEW` Dev script supports update command for master branch
- `NEW` Live loading bar is included
- `NEW` Dev script supports building production assets
- `FIX` Assets in production mode are correctly built
- `NEW` Readme page was added
- `NEW` Functional tests for pages
- `NEW` Dev script supports running tests in watch mode
- `NEW` Dev script supports shortcuts
- `NEW` Settings page was added
- `CNG` Change link generation
- `NEW` My account page was added
- `NEW` New message page was added
- `NEW` Changelog page was added
- `NEW` Approval page was added
- `NEW` Organization messages page was added
- `NEW` All messages page was added
- `NEW` Dashboard page was added
- `NEW` Localization is implemented
- `NEW` Footer stays on bottom
- `CNG` Attach to IEx session when starting the stack
- `NEW` The footer component is implemented
- `NEW` A navigation component is implemented
- `NEW` Dashboard dummy as starting page
- `NEW` Basic layout is added
- `NEW` Application scaffold is created with LiveView enabled

---

## Legend

- `NEW` means a new feature
- `CNG` means changed behavior
- `FIX` means a bugfix or fix of a glitch
- `REM` means a removed feature
