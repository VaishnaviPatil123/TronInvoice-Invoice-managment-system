package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.demo.InvoiceItemEntity;

public interface InvoiceItemRespo  extends JpaRepository<InvoiceItemEntity, Long>{

}
