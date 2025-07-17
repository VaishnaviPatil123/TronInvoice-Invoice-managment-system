package com.example.demo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface PharmRepository extends JpaRepository<PharmEntity, Long>{
	
	 List<PharmEntity> findByBarcodeContainingIgnoreCase(String barcode);
	 
	 List<PharmEntity> findByType(String type);   
	 
	 PharmEntity findByBarcode(String barcode);
	 
	 
	 // Count of products that are in stock
	    long countByQuantityGreaterThan(int quantity);  // In Stock

	    // Count of products that are out of stock
	    long countByQuantity(int quantity);  // Out of Stock

	    // Count of products that have low stock (e.g., quantity < 10)
	    long countByQuantityLessThan(int quantity);  // Low Stock
	    
	    
	    
	 // Method to find products with quantity greater than 0 (In Stock)
	    List<PharmEntity> findByQuantityGreaterThan(int quantity);  // In Stock

	    // Method to find products with quantity equal to 0 (Out of Stock)
	    List<PharmEntity> findByQuantity(int quantity);  // Out of Stock

	    // Method to find products with quantity less than 10 (Low Stock)
	    List<PharmEntity> findByQuantityLessThan(int quantity);  // Low Stock



}
