Here's the full status against the rejection:                                                                                       
  #: 1                                                                                                                                
  Guideline: 2.1                                                                                                                      
  Issue: Placeholder app icon                                                                                                         
  Status: Done (commit 91610020390c)                                                                                                  
  ────────────────────────────────────────                                                                                            
  #: 2
  Guideline: 2.3.3                                                                                                                    
  Issue: iPad screenshots are stretched iPhone images                                                                                 
  Status: Done (you uploaded proper iPad screenshots)                                                                                 
  ────────────────────────────────────────                                                                                            
  #: 3                                                                                                                                
  Guideline: 5.1.1                                                                                                                    
  Issue: Phone number required
  Status: Not an issue — phone number is never collected anywhere in the app. Not in signup, not in profile, not in the user model.
    Apple may have been confused. You should reply in App Store Connect explaining this.
  ────────────────────────────────────────
  #: 4
  Guideline: 5.1.1(v)
  Issue: No account deletion
  Status: Done — full 7-step deletion flow exists in Edit Profile > Danger Zone (re-auth, cancel proposals, anonymize data, delete
    Firestore doc, delete Firebase Auth account)
  ────────────────────────────────────────
  #: 5
  Guideline: 2.1
  Issue: App doesn't load on iPad
  Status: Done (commit 2a936f137917)
  The only action item is Guideline 5.1.1 (phone number) — you need to reply to Apple explaining that the app does NOT require a phone
   number. Here's a suggested response you can paste into App Store Connect:

  ---
  Re: Guideline 5.1.1 — Phone Number

  Thank you for the review. Our app does not require or collect a phone number at any point during registration or use. Account
  creation only requires a name, email, password, and skill level. There is no phone number field in the signup flow, user profile, or
   data model.

  We believe this may have been flagged in error. Please let us know if you need further clarification.

  ---
  Everything else is addressed. You're good to upload build 5 via Transporter and resubmit.