# Social_media
It's a social media platform with features like

## Features

- [x] **1. Signup + Validation**
  - [x] Length, format of email, password, mobile no
  - [x] Account verification using link (recommended) or OTP (alternate option)

- [x] **2. Login + Validation**
  - [x] Email and password format
  - [x] JWT for authentication and authorization

- [x] **3. Forgot Password**
  - [x] Action1 - Send OTP on email
  - [x] Action2 - Verify OTP and reset the password

- [x] **4. Account Update**
  - [x] Using authorization token
  - [ ] Refresh token concept in case of token expiration

- [x] **5. Post Operations**
  - [x] Create, update, and delete posts
  - [x] Read all posts with pagination

- [x] **6. Comments**
  - [ ] CRUD operations on post comments

- [x] **7. Like and Unlike**
  - [x] Posts and comments using polymorphic association
  - [ ] Separate API for getting all likes on posts and comments

- [x] **8. Friend Management**
  - [x] Add friends with pending, accepted, and decline states
  - [ ] Resend friend request after 30 days if declined
  - [ ] Block user and remove from friend list (persistent even after unblocking)

- [x] **9. Post Visibility**
  - [ ] Make posts public, private, and only visible to friends

- [ ] **10. Share Post**
  - [ ] Public and only visible to friends
  - [ ] Remove shared post if friend is unfriended
  - [ ] Deactivate shared post if unfriended and reactive when becoming friends again

- [ ] **11. Media Attachments**
  - [ ] Attach profile_pic and cover_pic with the account
  - [ ] Attach image/images with posts and comments
  - [ ] Add reactions to posts and comments

- [ ] **12. User Reports**
  - [ ] Repost user blocking if reported by more than 100 users
  - [ ] Report post restriction if reported by more than 100 users (even author can't see)

- [ ] **13. Post Read Limitation**
  - [ ] Free_user - 10 posts per day
  - [ ] Premium_user - unlimited
  - [ ] Daily credit of 10 posts for free_user (using sidekiq and cron)

- [ ] **14. Subscription**
  - [ ] Free and premium user types
  - [ ] Stripe payment integration
