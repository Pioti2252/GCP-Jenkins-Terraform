terraform {
  backend "gcs" {
    bucket  = "ftstate"
    prefix  = "state"
  }
}