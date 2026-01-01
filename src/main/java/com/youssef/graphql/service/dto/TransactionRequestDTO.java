package com.youssef.graphql.service.dto;

import com.youssef.graphql.service.model.enums.BankTransactionType;
import java.util.Date;

public record BankTransactionRequestDTO(
        Long BankAccountId,
        double amount,
        Date date,
        BankTransactionType type
) {
}
