package com.example.demo;

import java.util.List;
import java.util.Optional;

public interface InvoiceService {

    // Create and save an invoice (now saving invoice items directly)
	InvoiceEntity createInvoice(List<InvoiceItemEntity> items, String customerName, String customerPhoneNumber);
    List<InvoiceEntity> getAllInvoices();
    
    Optional<InvoiceEntity> getInvoiceById(Long id); 

  

    void deleteInvoice(Long id);


}
