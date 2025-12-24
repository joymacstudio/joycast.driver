# Pre-Release Check

Verify the project is ready for submission to App Store / Setapp / distribution.

This is not about code quality (that's `/audit`). This is about: "Can we submit this build with confidence?"

## Phase 1: Discovery

### Identify Release Target
- What platform? (App Store, Setapp, direct distribution, TestFlight)
- What version are we releasing?
- First release or update?

### Identify All Components
Scan the repository and CLAUDE.md to find everything that's part of this release:

- **macOS App** — the core product
- **API / Backend** — if the app depends on server infrastructure
- **Website** — landing page, marketing site, documentation
- **Other assets** — help files, sample content, etc.

List all components that need to be verified for this release.

## Phase 2: macOS App Verification

### Bundle & Identifiers
- [ ] Bundle ID is correct (not test/dev ID)
- [ ] Team ID matches distribution account
- [ ] App ID registered in Developer Portal
- [ ] Entitlements match app capabilities

### Versioning
- [ ] Version number is correct (CFBundleShortVersionString)
- [ ] Build number is incremented (CFBundleVersion)
- [ ] Version matches what's expected for this release

### Platform-Specific

**If Setapp:**
- [ ] Setapp SDK integrated and initialized
- [ ] Setapp vendor ID configured
- [ ] License check works correctly

**If App Store:**
- [ ] App Store Connect entry exists
- [ ] In-app purchases configured (if any)
- [ ] App Privacy labels up to date

### Code Signing & Notarization
- [ ] Signed with correct certificate (Distribution, not Development)
- [ ] Provisioning profile is valid and not expired
- [ ] Hardened runtime enabled
- [ ] No unsigned frameworks or plugins
- [ ] App is notarized
- [ ] Notarization ticket stapled
- [ ] `spctl --assess` passes

### Build Artifacts
- [ ] Release build (not Debug)
- [ ] No debug symbols in production
- [ ] No test/mock data included
- [ ] No console logging of sensitive data

## Phase 3: Infrastructure Verification

### API / Backend (if exists)
- [ ] Production endpoints are live and responding
- [ ] API version matches what app expects
- [ ] Authentication/authorization works
- [ ] Rate limits appropriate for launch
- [ ] Error responses are correct (not debug info)
- [ ] SSL certificates valid

### Website (if exists)
- [ ] Site is live and accessible
- [ ] Download links point to correct version
- [ ] Screenshots/videos are up to date
- [ ] Pricing information is correct
- [ ] All pages load without errors

## Phase 4: Resources & Links

### App Resources
- [ ] App icon present in all required sizes
- [ ] Launch screen / splash configured
- [ ] Localization files complete (if localized)

### External Links (verify all work)
- [ ] Support URL
- [ ] Privacy Policy URL
- [ ] Terms of Service URL
- [ ] Marketing website
- [ ] Documentation / Help

### Store Metadata (if applicable)
- [ ] Screenshots ready for required device sizes
- [ ] App description ready
- [ ] What's New / Release Notes written
- [ ] Keywords / categories selected

## Phase 5: Functional Smoke Test

Quick verification that everything works together:
- [ ] App launches without crash
- [ ] Main user flow completes
- [ ] License/subscription check works
- [ ] App-to-server communication works (if applicable)
- [ ] No obvious UI issues
- [ ] Permissions requested correctly

## Report

Generate a checklist summary:

### ✅ Passed
[List all passed checks]

### ❌ Failed (blockers)
[List failed checks with details — must fix before submission]

### ⚠️ Warnings
[Things that passed but should be double-checked manually]

### Components Verified
- App: [version]
- API: [status]
- Website: [status]

**Only proceed with submission if all critical checks pass.**
