# Bank GraphQL Service

## Overview
A GraphQL API for bank account management using Spring Boot and Spring GraphQL.
Refactored by **Youssef Bahaddou**.

## Features
- **GraphQL API**: Query and Mutate data efficiently.
- **H2 Database**: In-memory storage.
- **Transactions**: Manage deposits and withdrawals.

## Schema
See \src/main/resources/graphql/schema.graphqls\ for full definition.

## Queries (Example)
\\\graphql
query {
  allAccounts {
    id
    balance
    type
  }
}
\\\

## Run
\\\ash
mvn spring-boot:run
\\\
Then access \http://localhost:8082/graphiql\

## Author
Youssef Bahaddou

