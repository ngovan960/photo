# Beta Testing Checklist — Photo ID

## Pre-Beta Setup

- [ ] Firebase project configured
- [ ] RevenueCat configured
- [ ] AdMob configured
- [ ] TestFlight (iOS) configured
- [ ] Play Console (Android) configured
- [ ] Beta testing group created (100 users)

## Functional Testing

### Camera
- [ ] Camera preview displays correctly
- [ ] Flash toggle works
- [ ] Camera switch (front/back) works
- [ ] Capture button works
- [ ] Guide overlay displays correctly
- [ ] Face detection indicator works

### Photo Processing
- [ ] Background removal works
- [ ] Background color change works (white, blue, red, gray)
- [ ] Crop & resize works
- [ ] Validation checklist works
- [ ] Photo quality score displays correctly

### Export
- [ ] Single photo export works
- [ ] Grid layout export works (4 copies, 8 copies)
- [ ] JPEG export works
- [ ] PNG export works
- [ ] Save to gallery works
- [ ] Share works

### History
- [ ] Photo history saves correctly
- [ ] Photo history loads correctly
- [ ] Photo detail displays correctly
- [ ] Delete photo works

### Settings
- [ ] Theme toggle works (light/dark)
- [ ] Language selection works
- [ ] Auto-delete setting works
- [ ] Cache display works

### Subscription
- [ ] Paywall displays correctly
- [ ] Purchase flow works
- [ ] Restore purchases works
- [ ] Quota tracking works

## Performance Testing

- [ ] Cold start < 3 seconds
- [ ] Face detection < 500ms
- [ ] Background removal < 2 seconds
- [ ] Export < 1 second
- [ ] Memory usage < 300MB
- [ ] No memory leaks

## Device Testing

### iOS
- [ ] iPhone 12 or newer
- [ ] iPhone SE (2nd gen)
- [ ] iPad (optional)

### Android
- [ ] Samsung Galaxy S21 or newer
- [ ] Pixel 6 or newer
- [ ] Low-end device (Redmi 9A)

## Accessibility Testing

- [ ] VoiceOver (iOS) works
- [ ] TalkBack (Android) works
- [ ] Dynamic type works
- [ ] Color contrast meets WCAG AA

## Security Testing

- [ ] No photos uploaded to server
- [ ] EXIF stripped on export
- [ ] Biometric lock works
- [ ] Encryption works

## Bug Report Template

```
**Device:** [Model, OS version]
**App Version:** [Version number]
**Steps to Reproduce:**
1. ...
2. ...
3. ...

**Expected Result:** [What should happen]
**Actual Result:** [What actually happened]
**Screenshots:** [If applicable]
```

## Sign-off

- [ ] All critical bugs fixed
- [ ] All high-priority bugs fixed
- [ ] Performance targets met
- [ ] Accessibility targets met
- [ ] Security review passed
- [ ] Ready for production
