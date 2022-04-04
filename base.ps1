Configuration base {
    Import-DscResource -ModuleName "myServiceModule"

    Node localhost {
        myService W32Time {
            serviceName = "W32Time"
        }
    }
}