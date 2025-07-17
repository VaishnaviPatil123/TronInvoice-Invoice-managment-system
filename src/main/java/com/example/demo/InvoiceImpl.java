package com.example.demo;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InvoiceImpl implements InvoiceService {

    @Autowired
    private InvoiceItemRespo invoiceItemRespo;

    @Autowired
    private InvoiceRespo invoiceRespo;

    @Override
    public InvoiceEntity createInvoice(List<InvoiceItemEntity> items, String customerName, String customerPhone) {
        double total = 0.0;
        LocalDateTime now = LocalDateTime.now(); // Store current timestamp once

        // 1. Create the invoice entity
        InvoiceEntity invoice = new InvoiceEntity();
        invoice.setInvoiceNumber("INV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        invoice.setCustomerName(customerName);
        invoice.setCustomerPhoneNumber(customerPhone);
        invoice.setCreationDateTime(now); // Set invoice creation time

        // 2. Prepare each item
        for (InvoiceItemEntity item : items) {
            item.setCreationDateTime(now); // ✅ Set item creation time
            item.calculateNetTotal();      // ✅ Calculate GST-inclusive total
            item.setInvoice(invoice);      // ✅ Link to parent invoice
            total += item.getNetTotal();   // ✅ Add to total
        }

        // 3. Assign total and save
        invoice.setTotalAmount(total);
        invoice.setItems(items);

        return invoiceRespo.save(invoice); // ✅ Will cascade and save items
    }

    @Override
    public List<InvoiceEntity> getAllInvoices() {
        return invoiceRespo.findAll();
    }

    @Override
    public Optional<InvoiceEntity> getInvoiceById(Long id) {
        return invoiceRespo.findById(id);
    }
    

    @Override
    public void deleteInvoice(Long id) {
    	invoiceRespo.deleteById(id);
    }
}
