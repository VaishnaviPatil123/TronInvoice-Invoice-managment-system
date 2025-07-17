package com.example.demo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



@Service
public class PharmSerImple implements PharmService {
	
	@Autowired
    private PharmRepository pr;
	
	 @Override
	    public void save(PharmEntity entity) {
	        pr.save(entity);
	    }

	 @Override
	    public List<PharmEntity> getAllProducts() {
	        return pr.findAll();
	    }
	 @Override
	 public PharmEntity getProductById(Long id) {
	     return pr.findById(id).orElse(null);
	 }

	 @Override
	 public void deleteProductById(Long id) {
	     pr.deleteById(id);
	 }
	 
	 @Override
	    public List<PharmEntity> getProductsByBarcode(String barcode) {
	        return pr.findByBarcodeContainingIgnoreCase(barcode);
	    }
	 
	 @Override
	 public List<PharmEntity> getProductsByType(String type) {
	     return pr.findByType(type); // In Stock / Out of Stock
	 }
	 
	 
	 @Override
	    public PharmEntity getProductByBarcode(String barcode) {
	        return pr.findByBarcode(barcode);
	    }



}
