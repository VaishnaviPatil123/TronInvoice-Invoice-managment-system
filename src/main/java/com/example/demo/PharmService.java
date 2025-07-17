package com.example.demo;

import java.util.List;





public interface PharmService {
	
	void save(PharmEntity entity);
	
	List<PharmEntity> getAllProducts();
	
	PharmEntity getProductById(Long id);
	
	void deleteProductById(Long id);
	
	  List<PharmEntity> getProductsByBarcode(String barcode);
	  
	  List<PharmEntity> getProductsByType(String type);
	  
	  PharmEntity  getProductByBarcode(String barcode);

	  

}
