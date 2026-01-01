package com.youssef.graphql.service.repository;

import com.youssef.graphql.service.model.BankAccount;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface BankAccountRepository extends JpaRepository<BankAccount, Long> {
    @Query("SELECT COALESCE(SUM(c.balance), 0) FROM BankAccount c")
    Double sumbalances();
}

