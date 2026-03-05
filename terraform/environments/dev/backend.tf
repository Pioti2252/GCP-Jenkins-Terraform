terraform {
  backend "gcs" {
    bucket  = "first-jenkins-488416-tfstate"
    prefix  = "tfstate"
  }
}