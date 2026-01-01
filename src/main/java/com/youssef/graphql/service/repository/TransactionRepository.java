package com.youssef.graphql.service.repository;

import com.youssef.graphql.service.model.BankAccount;
import com.youssef.graphql.service.model.BankBankTransaction;
import com.youssef.graphql.service.model.enums.BankTransactionType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BankTransactionRepository extends JpaRepository<BankTransaction, Long> {

    // Trouver les BankTransactions pour un BankAccount donné
    List<BankTransaction> findByBankAccount(BankAccount BankAccount);

    // Calculer la somme par type (utilisé pour les statistiques)
    @Query("SELECT COALESCE(SUM(t.amount), 0) FROM BankTransaction t WHERE t.type = :type")
    double sumByType(@Param("type") BankTransactionType type);
}
