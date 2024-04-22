Import-Csv -Path C:\Users\admin\Documents\users_18_01_2024_17_30_50.csv -Delimiter ';' -PipelineVariable User | ForEach-Object -Process {
    $password = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 20 |ForEach-Object -Process {[char]$_} )
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
    $NewAdUserParameters = @{
        GivenName = $User.Nome
        Surname = $User.Sobrenome
        DisplayName = ('{0} {1}' -f $User.Nome, $User.Sobrenome)
        Name = $User.NomeAcesso
        Description = 'Usuário criado via Script'
        AccountPassword = $securePassword
        Enabled = $true
        UserPrincipalName = '{0}@{1}' -f $User.NomeAcesso, $((Get-ADDomain).DNSRoot)
        ChangePasswordAtLogon = $true
        Verbose = $true
    }
    New-AdUser @NewAdUserParameters
}