# Importa os dados do CSV
$data = Import-Csv -Path "C:\Caminho\Para\Seu\Arquivo.csv"

# Loop pelos dados do CSV e cria usuários no Active Directory
foreach ($user in $data) {
    $firstName = $user.'Nome'
    $lastName = $user.'Sobrenome'
    $displayName = $user.'Nome para Exibição'
    $userLogonName = $user.'Nome UPN'
    $proxyAddresses = $user.'Endereços de proxy'

    # Cria uma senha aleatória
    $password = [System.Web.Security.Membership]::GeneratePassword(12, 3)

    # Cria um objeto de senha
    $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

    # Configura as propriedades do novo usuário
    $userParams = @{
        'GivenName'        = $firstName
        'Surname'          = $lastName
        'DisplayName'      = $displayName
        'SamAccountName'   = $userLogonName
        'UserPrincipalName'= "$userLogonName@decisao.agr.br" # Substitua 'seudominio.com' pelo seu domínio
        'ProxyAddresses'   = $proxyAddresses -split '\+'
        'AccountPassword'  = $securePassword
        'Enabled'          = $true
        'PasswordNeverExpires' = $true
    }

    # Cria o usuário no Active Directory
    New-ADUser @userParams

    Write-Host "Usuário $userLogonName criado com sucesso."
}
