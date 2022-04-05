Configuration newBase {
    Import-DSCResource -module "MyDscResource"

    MySvc testFile {
        ServiceName = "W32Time"
        Ensure      = "Running"
    }
}
