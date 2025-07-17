package com.example.demo;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class PharmEntity {
	
	  @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    private String barcode;
	    private String name;
	    private int quantity;
	    private double cost;
	    private double gstPercentage;
	    private double sgstAmount;
	    private double cgstAmount;
	    private double totalGst;
	    private double netTotal;
	    private String type;
	    
	  
	    
		public Long getId() {
			return id;
		}
		public void setId(Long id) {
			this.id = id;
		}
		public String getBarcode() {
			return barcode;
		}
		public void setBarcode(String barcode) {
			this.barcode = barcode;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public int getQuantity() {
			return quantity;
		}
		public void setQuantity(int quantity) {
			this.quantity = quantity;
		}
		public double getCost() {
			return cost;
		}
		public void setCost(double cost) {
			this.cost = cost;
		}
		public double getGstPercentage() {
			return gstPercentage;
		}
		public void setGstPercentage(double gstPercentage) {
			this.gstPercentage = gstPercentage;
		}
		public double getSgstAmount() {
			return sgstAmount;
		}
		public void setSgstAmount(double sgstAmount) {
			this.sgstAmount = sgstAmount;
		}
		public double getCgstAmount() {
			return cgstAmount;
		}
		public void setCgstAmount(double cgstAmount) {
			this.cgstAmount = cgstAmount;
		}
		public double getTotalGst() {
			return totalGst;
		}
		public void setTotalGst(double totalGst) {
			this.totalGst = totalGst;
		}
		public double getNetTotal() {
			return netTotal;
		}
		public void setNetTotal(double netTotal) {
			this.netTotal = netTotal;
		}
		public String getType() {
			return type;
		}
		public void setType(String type) {
			this.type = type;
		}
		


}
