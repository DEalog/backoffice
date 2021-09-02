## Unreleased

- `NEW` Add administrative area filter to approvals
- `NEW` Add administrative filter to my organization
- `FIX` Fix form field styles
- `NEW` ARS IDs are projected for filtering
- `NEW` Add export of ARS for Heilbronn
- `NEW` The confirmation email can be resent
- `FIX` Organization is sent correctly to the message service
- `NEW` Messages can have a category attached
- `FIX` Add missing event store migration
- `CNG` Improve preview deployments
- `CNG` Update Elixir dependencies
- `FIX` Fix publishing ARS and organization via Kafka

## 0.5.0

This release provides the user system.

- `FIX` Sending message for approval is possible again
- `NEW` All message actions are disabled when the account is incomplete
- `NEW` User gets a warning when account is not setup
- `NEW` Author and organization meta data is saved for all message related events
- `NEW` Check origin config for websocket connections is introduced
- `CNG` Move hostname config to release
- `NEW` Release startup actions are logged properly
- `FIX` The updated date on the message for approval projection was fixed
- `FIX` The updated date on the created message projection was fixed
- `NEW` Support module to rebuild account projections was added
- `NEW` Support module to rebuild message projections was added
- `REM` Rebuild projections script was removed
- `NEW` Sample data can be loaded to the application for development
- `NEW` Changed published messages can be reverted to published state and archived
- `NEW` Changes on published messages can be discarded
- `NEW` Published messages can be archived (taken offline)
- `CNG` Changelog is cleaned up
- `CNG` Administrative areas are preloaded differently
- `CNG` Login and other user related pages are centered on the screen
- `NEW` The category of the message being published is added (hard coded at the moment)
- `NEW` The organization of the message being published is added (hard coded at the moment)
- `NEW` The ars code of the message being published is added (hard coded at the moment)
- `NEW` A super user can be created if email and password is supplied
- `NEW` Publishing of messsages to Kafka is logged
- `NEW` All command dispatches are logged
- `FIX` Publish at is sent as a timestamp instead of a ISO 8601 string
- `FIX` Type of first time published messages is changed to `Created`
- `NEW` Messages that already have been published are detected as updated ones
- `FIX` Message payload is now compatible with the Message Service
- `FIX` Project information (readme) can be viewed on released instances
- `NEW` Users are anonymously tracked to get some metrics
- `NEW` User accounts can be changed
- `NEW` Users can be onboarded with an account containing the personal data as well as the organizational settings
- `NEW` Users are listed in the settings area
- `CNG` Frontend dependecies are updated
- `FIX` Login with unconfirmed users issues is handled by emitting a user or password wrong message
- `FIX` The Kafka configuration is read correctly when no projectors are configured
- `NEW` Setup GH Actions to deploy application to AWS
- `CNG` Send ARS instead of a geocode to Kafka
- `CNG` Structure of administrative areas is changed to ARS (from AGS)
- `NEW` Mail support for registration, password reset, email change is available
- `CNG` Update dependencies
- `NEW` Authentication is implemented for all content pages
- `NEW` Users can change their email address
- `NEW` Users can change their password
- `NEW` Users can authenticate
- `NEW` Users can register

## 0.4.0

This release covers message publishing for a single organization.

- `NEW` Forms have cancel buttons
- `CNG` Deployments are update to use the new default branch `main`
- `CNG` Adapt dev script for new default branch `main`
- `CNG` Import of administrative areas is running on container start (until there is support for one-off tasks)
- `NEW` Administrative areas can be imported
- `FIX` The Kafka host can be configured via an env var
- `NEW` Published message details can be viewed
- `NEW` Published messages are shown in the all messages list
- `NEW` Preview deployment cleanup supports custom branches
- `NEW` Published messages get distributed to Kafka if enabled
- `NEW` Messages that are approved can be published
- `CNG` Projection reset script can be run in prod as well (with a security flag)
- `FIX` Tag name for master build
- `FIX` Fix GH Action output for deployment
- `NEW` Manual preview deployments are available
- `NEW` A health endpoint is added for monitoring
- `NEW` Application can be deployed via mix release on Docker
- `CNG` Rejected messages are removed from the approval section
- `CNG` Improve message listings
- `NEW` Messages can be deleted

## 0.3.0

This release has a basic approval process for a single organization on board.

- `CNG` Redirects of actions on message refer to the detail view of that message
- `NEW` Approved messages can have a note attached to them
- `NEW` Messages waiting for approval can be approved
- `NEW` Message details can be viewed for approvals
- `NEW` Message details can be viewed for my organization
- `NEW` Rejected messages can have a reason
- `NEW` Messages waiting for approval can be rejected
- `NEW` Dev script has a task to reset the task database
- `NEW` Messages waiting for approval are listed in the approvals section
- `NEW` Messages can be sent for approval
- `NEW` Error messages are displayed as notification
- `CNG` No change saves do not emit a changed event
- `NEW` Favicons are added
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
