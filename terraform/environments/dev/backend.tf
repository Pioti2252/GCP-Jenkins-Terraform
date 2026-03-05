terraform {
  backend "gcs" {
    bucket  = "first-jenkins-488416-ftstate"
    prefix  = "ftstate/state"
  }
}