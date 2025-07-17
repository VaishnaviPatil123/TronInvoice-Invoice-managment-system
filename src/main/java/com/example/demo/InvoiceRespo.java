package com.example.demo;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface InvoiceRespo  extends JpaRepository<InvoiceEntity, Long> {
	
	 @Query("SELECT SUM(i.totalAmount) FROM InvoiceEntity i")
	    Double sumOfTotalAmount();  // 👈 This gives total sales
	 
	 @Query("SELECT COUNT(i) FROM InvoiceEntity i WHERE DATE(i.creationDateTime) = CURRENT_DATE")
	 long countTodayInvoices();

	 @Query("SELECT SUM(i.totalAmount) FROM InvoiceEntity i WHERE DATE(i.creationDateTime) = CURRENT_DATE")
	 Double sumTodaySales();

	 List<InvoiceEntity> findByCreationDateTimeBetween(LocalDateTime start, LocalDateTime end);


}
