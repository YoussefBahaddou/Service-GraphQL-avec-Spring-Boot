$projectPath = "C:\DEV\Lechgar\DrissLechgarRepo\SeleniumScripts\downloads\TP-15 ( id 168 )\TP-15-Service-GraphQL-avec-Spring-Boot-main"
$srcMainJava = "$projectPath\src\main\java"
$srcMainRes = "$projectPath\src\main\resources"
$oldPackagePath = "$srcMainJava\com\example\banqueservice"
$newPackagePath = "$srcMainJava\com\youssef\graphql\service"

# 1. Create New Package Structure
New-Item -ItemType Directory -Force -Path "$newPackagePath\model\enums" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\repository" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\controller" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\dto" | Out-Null
New-Item -ItemType Directory -Force -Path "$newPackagePath\exception" | Out-Null

# 2. Move and Rename Core Files
# Main App
if (Test-Path "$oldPackagePath\Tp15Application.java") {
    Move-Item "$oldPackagePath\Tp15Application.java" "$newPackagePath\BankGraphqlApplication.java" -Force
}

# Entities
if (Test-Path "$oldPackagePath\entities\Compte.java") {
    Move-Item "$oldPackagePath\entities\Compte.java" "$newPackagePath\model\BankAccount.java" -Force
}
if (Test-Path "$oldPackagePath\entities\Transaction.java") {
    Move-Item "$oldPackagePath\entities\Transaction.java" "$newPackagePath\model\BankTransaction.java" -Force
}

# Enums
if (Test-Path "$oldPackagePath\enums\TypeCompte.java") {
    Move-Item "$oldPackagePath\enums\TypeCompte.java" "$newPackagePath\model\enums\AccountType.java" -Force
}
if (Test-Path "$oldPackagePath\enums\TypeTransaction.java") {
    Move-Item "$oldPackagePath\enums\TypeTransaction.java" "$newPackagePath\model\enums\TransactionType.java" -Force
}

# Repositories
if (Test-Path "$oldPackagePath\repositories\CompteRepository.java") {
    Move-Item "$oldPackagePath\repositories\CompteRepository.java" "$newPackagePath\repository\BankAccountRepository.java" -Force
}
if (Test-Path "$oldPackagePath\repositories\TransactionRepository.java") {
    Move-Item "$oldPackagePath\repositories\TransactionRepository.java" "$newPackagePath\repository\TransactionRepository.java" -Force
}

# Controllers
if (Test-Path "$oldPackagePath\controllers\CompteController.java") {
    Move-Item "$oldPackagePath\controllers\CompteController.java" "$newPackagePath\controller\AccountController.java" -Force
}
if (Test-Path "$oldPackagePath\controllers\TransactionController.java") {
    Move-Item "$oldPackagePath\controllers\TransactionController.java" "$newPackagePath\controller\TransactionController.java" -Force
}

# DTOs
if (Test-Path "$oldPackagePath\dto\TransactionRequest.java") {
    Move-Item "$oldPackagePath\dto\TransactionRequest.java" "$newPackagePath\dto\TransactionRequestDTO.java" -Force
}

# Exception Handler
if (Test-Path "$oldPackagePath\GraphQLExceptionHandler.java") {
    Move-Item "$oldPackagePath\GraphQLExceptionHandler.java" "$newPackagePath\exception\CustomGraphQLExceptionHandler.java" -Force
}

# 3. Remove Old Directories
Remove-Item "$srcMainJava\com\example" -Recurse -Force -ErrorAction SilentlyContinue

# 4. Overwrite GraphQL Schema (French -> English)
$schemaContent = @"
enum AccountType {
    CHECKING
    SAVINGS
}

type BankAccount {
    id: ID
    balance: Float
    creationDate: String
    type: AccountType
    customerName: String
}

type AccountStats {
    count: Int
    sum: Float
    average: Float
}

type Query {
    allAccounts: [BankAccount]
    accountById(id: ID!): BankAccount
    totalBalance: AccountStats
    accountTransactions(id: ID!): [BankTransaction]
}

input AccountInput {
    balance: Float!
    creationDate: String!
    type: AccountType!
}

type Mutation {
    createAccount(account: AccountInput): BankAccount
    addTransaction(transaction: TransactionRequest): BankTransaction
}

enum TransactionType {
    DEPOSIT
    WITHDRAWAL
}

type BankTransaction {
    id: ID
    date: String
    amount: Float
    type: TransactionType
    account: BankAccount
}

input TransactionRequest {
    accountId: ID!
    amount: Float!
    date: String!
    type: TransactionType!
}
"@
Set-Content -Path "$srcMainRes\graphql\schema.graphqls" -Value $schemaContent

# 5. Content Replacement (Java)
$filesToUpdate = Get-ChildItem -Path "$newPackagePath" -Recurse -Filter "*.java"

foreach ($file in $filesToUpdate) {
    $content = Get-Content $file.FullName -Raw

    # Package Declarations
    $content = $content -replace "package com.example.banqueservice;", "package com.youssef.graphql.service;"
    $content = $content -replace "package com.example.banqueservice.entities;", "package com.youssef.graphql.service.model;"
    $content = $content -replace "package com.example.banqueservice.enums;", "package com.youssef.graphql.service.model.enums;"
    $content = $content -replace "package com.example.banqueservice.repositories;", "package com.youssef.graphql.service.repository;"
    $content = $content -replace "package com.example.banqueservice.controllers;", "package com.youssef.graphql.service.controller;"
    $content = $content -replace "package com.example.banqueservice.dto;", "package com.youssef.graphql.service.dto;"

    # Imports
    $content = $content -replace "import com.example.banqueservice.entities.Compte;", "import com.youssef.graphql.service.model.BankAccount;"
    $content = $content -replace "import com.example.banqueservice.entities.Transaction;", "import com.youssef.graphql.service.model.BankTransaction;"
    $content = $content -replace "import com.example.banqueservice.enums.TypeCompte;", "import com.youssef.graphql.service.model.enums.AccountType;"
    $content = $content -replace "import com.example.banqueservice.enums.TypeTransaction;", "import com.youssef.graphql.service.model.enums.TransactionType;"
    $content = $content -replace "import com.example.banqueservice.repositories.CompteRepository;", "import com.youssef.graphql.service.repository.BankAccountRepository;"
    $content = $content -replace "import com.example.banqueservice.repositories.TransactionRepository;", "import com.youssef.graphql.service.repository.TransactionRepository;"
    $content = $content -replace "import com.example.banqueservice.dto.TransactionRequest;", "import com.youssef.graphql.service.dto.TransactionRequestDTO;"

    # Class Names
    $content = $content -replace "Tp15Application", "BankGraphqlApplication"
    $content = $content -replace "CompteController", "AccountController"
    $content = $content -replace "CompteRepository", "BankAccountRepository"
    $content = $content -replace "Compte", "BankAccount"
    $content = $content -replace "TypeCompte", "AccountType"
    $content = $content -replace "TypeTransaction", "TransactionType"
    $content = $content -replace "TransactionRequest", "TransactionRequestDTO"
    $content = $content -replace "Transaction", "BankTransaction" # Might conflict with TransactionRequestDTO, need care? No because strict replace.
    
    # GraphQL Mappings (French -> English)
    $content = $content -replace '"allComptes"', '"allAccounts"'
    $content = $content -replace '"compteById"', '"accountById"'
    $content = $content -replace '"totalSolde"', '"totalBalance"'
    $content = $content -replace '"saveCompte"', '"createAccount"'
    $content = $content -replace '"compteTransactions"', '"accountTransactions"'
    
    # Variable Naming
    $content = $content -replace "solde", "balance"
    $content = $content -replace "dateCreation", "creationDate"
    $content = $content -replace "compte", "account"
    $content = $content -replace "montant", "amount"
    
    # Enum Values
    $content = $content -replace "COURANT", "CHECKING"
    $content = $content -replace "EPARGNE", "SAVINGS"
    $content = $content -replace "DEPOT", "DEPOSIT"
    $content = $content -replace "RETRAIT", "WITHDRAWAL"

    Set-Content -Path $file.FullName -Value $content
}

# 6. Update POM
$pomPath = "$projectPath\pom.xml"
if (Test-Path $pomPath) {
    (Get-Content $pomPath) -replace "com.example", "com.youssef" `
                           -replace "banqueservice", "bank-graphql-service" `
                           -replace "<name>banqueservice</name>", "<name>Bank GraphQL Service</name>" | Set-Content $pomPath
}

# 7. Create README
$readmeContent = "# Bank GraphQL Service

## Overview
A GraphQL API for bank account management using Spring Boot and Spring GraphQL.
Refactored by **Youssef Bahaddou**.

## Features
- **GraphQL API**: Query and Mutate data efficiently.
- **H2 Database**: In-memory storage.
- **Transactions**: Manage deposits and withdrawals.

## Schema
See \`src/main/resources/graphql/schema.graphqls\` for full definition.

## Queries (Example)
\`\`\`graphql
query {
  allAccounts {
    id
    balance
    type
  }
}
\`\`\`

## Run
\`\`\`bash
mvn spring-boot:run
\`\`\`
Then access \`http://localhost:8082/graphiql\`

## Author
Youssef Bahaddou
"
Set-Content -Path "$projectPath\README.md" -Value $readmeContent

Write-Host "TP-15 Refactoring Complete!"
