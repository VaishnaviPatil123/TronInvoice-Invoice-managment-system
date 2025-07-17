package com.example.demo;










import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.example.demo.InvoiceItemEntity;
import com.example.demo.InvoiceItemRespo;
import java.io.OutputStream;  // CORRECT


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;




@Controller
public class PharmController {
	
	@Autowired
	PharmService ps;
	@Autowired
	InvoiceService is;
	
	 
	    @Autowired
	    private InvoiceItemRespo iir;
	    @Autowired
	    private InvoiceRespo ir;
	
	
	@GetMapping("/productList")
	public String showProductList(Model model) {
	    List<PharmEntity> products = ps.getAllProducts();
	    model.addAttribute("productList", products);
	    return "productList"; // productList.jsp
	}


	@GetMapping("/product")
	 public String showForm(@RequestParam(required = false) Long id, Model model) {
        if (id != null) {
            model.addAttribute("product", ps.getProductById(id)); // For Edit
        } else {
            model.addAttribute("product", new PharmEntity()); // For Add
        }
        model.addAttribute("productList", ps.getAllProducts());
        return "product";
    }
	
	@PostMapping("/saveProduct")
	public String submitProduct(@ModelAttribute("product") PharmEntity product) {
	    // Check if the type is "Out of Stock"
	    if ("Out of Stock".equals(product.getType())) {
	        // Set quantity to 0 if out of stock
	        product.setQuantity(0);
	    }

	    // Calculate the net total based on the quantity and other values (if required)
	    double totalCost = product.getCost() * product.getQuantity();
	    double gstAmount = (totalCost * product.getGstPercentage()) / 100;
	    double sgstAmount = gstAmount / 2;
	    double cgstAmount = gstAmount / 2;
	    double netTotal = totalCost + gstAmount;

	    // Update the values in the product entity
	    product.setSgstAmount(sgstAmount);
	    product.setCgstAmount(cgstAmount);
	    product.setTotalGst(gstAmount);
	    product.setNetTotal(netTotal);

	    // Save the updated product
	    ps.save(product);

	    return "redirect:/product";
	}


	 
	
	@GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        ps.deleteProductById(id);
        return "redirect:/product";
    }

	@GetMapping("/stock")
	public String viewStockPage(
	    @RequestParam(required = false) String barcode,
	    @RequestParam(required = false) String filterType,
	    Model model
	) {
	    List<PharmEntity> stockList;

	    // Prioritize barcode
	    if (barcode != null && !barcode.isEmpty()) {
	        stockList = ps.getProductsByBarcode(barcode); // will return only matching barcode
	    } else if (filterType != null && !filterType.isEmpty()) {
	        stockList = ps.getProductsByType(filterType); // e.g., "In Stock"
	    } else {
	        stockList = ps.getAllProducts(); // default all
	    }

	    model.addAttribute("stockList", stockList);
	    return "stock";
	}


	@GetMapping("/invoice")
	public String showInvoiceForm() {
	    return "invoice"; // will go to invoice.jsp
	}
	
	
	@PostMapping("/submit-customer")
	public String submitCustomerDetails(@RequestParam("customerName") String customerName,
	                                    @RequestParam("customerPhoneNumber") String customerPhoneNumber,
	                                    HttpSession session) {
	    session.setAttribute("customerName", customerName);
	    session.setAttribute("customerPhoneNumber", customerPhoneNumber);
	    session.setAttribute("showCustomer", true); // 👈 Add flag to show only once
	    return "redirect:/create-invoice";
	}



	
	
	 @GetMapping("/create-invoice")
	    public String showCreateInvoicePage(@RequestParam(value = "barcode", required = false) String barcode,
                 Model model,
                 HttpSession session) 
	 {
		 
	        if (barcode != null && !barcode.trim().isEmpty()) {
	            List<PharmEntity> searchedProducts = ps.getProductsByBarcode(barcode);
	            if (!searchedProducts.isEmpty()) {
	                model.addAttribute("searchedProduct", searchedProducts.get(0)); // show first matched product
	            } else {
	                model.addAttribute("searchedProduct", null);
	            }
	        }
	        // Get from session
	      //  String customerName = (String) session.getAttribute("customerName");
	       // String customerPhoneNumber = (String) session.getAttribute("customerPhoneNumber");

	      


	        // Get invoice items from session
	        List<InvoiceItemEntity> invoiceItems = (List<InvoiceItemEntity>) session.getAttribute("invoiceItems");
	        if (invoiceItems == null) {
	            invoiceItems = new ArrayList<>();
	        }

	        // Add attributes to the model
	        model.addAttribute("invoiceItems", invoiceItems);
	        model.addAttribute("total", invoiceItems.stream().mapToDouble(InvoiceItemEntity::getNetTotal).sum());
	        // Include customer details for summary page
	      //  model.addAttribute("customerName", customerName);
	      //  model.addAttribute("customerPhoneNumber", customerPhoneNumber);
return "invoice"; // your Thymeleaf or JSP page
	    }
	 
	 @PostMapping("/add-to-invoice")
	 public String addToInvoice(@RequestParam("barcode") String barcode,
	                            @RequestParam("quantity") int quantity,
	                            HttpSession session) {

	     // Fetch the product by barcode from your product service
	     List<PharmEntity> products = ps.getProductsByBarcode(barcode);
	     if (products.isEmpty()) {
	         // Product not found
	         return "redirect:/create-invoice?error=ProductNotFound";
	     }

	     PharmEntity product = products.get(0); // Take the first match

	     if (quantity <= 0) {
	         // Invalid quantity
	         return "redirect:/create-invoice?error=InvalidQuantity";
	     }

	     // Check if the product is in stock
	     if (product.getQuantity() < quantity) {
	         // Not enough stock for the requested quantity
	         return "redirect:/create-invoice?error=InsufficientStock";
	     }

	     // Calculate GST and other totals
	     double cost = product.getCost();
	     double gstPercentage = product.getGstPercentage();
	     double gstAmount = (cost * gstPercentage) / 100;
	     double totalGst = gstAmount * quantity;
	     double netTotal = (cost + gstAmount) * quantity;

	     // Create a new invoice item
	     InvoiceItemEntity item = new InvoiceItemEntity();
	     item.setBarcode(barcode);
	     item.setName(product.getName());
	     item.setCost(cost);
	     item.setGst(gstPercentage);
	     item.setQuantity(quantity);
	     item.setNetTotal(netTotal);

	     // Retrieve the current invoice items from session
	     List<InvoiceItemEntity> invoiceItems = (List<InvoiceItemEntity>) session.getAttribute("invoiceItems");
	     if (invoiceItems == null) {
	         invoiceItems = new ArrayList<>();
	     }

	     // Add the new item to the invoice items list
	     invoiceItems.add(item);

	     // Update the session with the new invoice items list
	     session.setAttribute("invoiceItems", invoiceItems);

	     // Redirect back to the create-invoice page to show the updated list
	     return "redirect:/create-invoice";
	 }

	 @GetMapping("/remove-item")
	 public String removeItem(@RequestParam("barcode") String barcode, HttpSession session) {
	     List<InvoiceItemEntity> invoiceItems = (List<InvoiceItemEntity>) session.getAttribute("invoiceItems");

	     if (invoiceItems != null) {
	         // Remove the item
	         invoiceItems.removeIf(item -> item.getBarcode().equals(barcode));

	         // Save updated list back to session
	         session.setAttribute("invoiceItems", invoiceItems);

	         // Recalculate total
	         double newTotal = 0.0;
	         for (InvoiceItemEntity item : invoiceItems) {
	             newTotal += item.getNetTotal();  // assuming netTotal is already calculated per item
	         }

	         session.setAttribute("total", newTotal); // update the total in session
	     }

	     return "redirect:/invoice";
	 }
	 
	 
	 

	 @PostMapping("/generate-invoice")
	 public String generateInvoice(HttpSession session, Model model) {
	     String customerName = (String) session.getAttribute("customerName");
	     String customerPhoneNumber = (String) session.getAttribute("customerPhoneNumber");
	     List<InvoiceItemEntity> invoiceItems = (List<InvoiceItemEntity>) session.getAttribute("invoiceItems");

	     if (invoiceItems != null && !invoiceItems.isEmpty()) {
	         double total = invoiceItems.stream().mapToDouble(InvoiceItemEntity::getNetTotal).sum();
	         String invoiceNumber = "INV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

	         session.setAttribute("invoiceNumber", invoiceNumber);
	         model.addAttribute("invoiceItems", invoiceItems);
	         model.addAttribute("total", total);
	         model.addAttribute("customerName", customerName);
	         model.addAttribute("customerPhoneNumber", customerPhoneNumber);
	         model.addAttribute("invoiceNumber", invoiceNumber);

	         return "invoice-summery";
	     }

	     return "redirect:/create-invoice";
	 }

	 
	 @PostMapping("/save-invoice")
	 public String saveInvoice(@RequestParam("paidAmount") double paidAmount,
	                            HttpSession session, Model model) {
	     String invoiceNumber = (String) session.getAttribute("invoiceNumber");
	     List<InvoiceItemEntity> invoiceItems = (List<InvoiceItemEntity>) session.getAttribute("invoiceItems");
	     String customerName = (String) session.getAttribute("customerName");
	     String customerPhoneNumber = (String) session.getAttribute("customerPhoneNumber");

	     if (invoiceItems != null && invoiceNumber != null) {
	         // Calculate total invoice amount
	         double total = invoiceItems.stream().mapToDouble(InvoiceItemEntity::getNetTotal).sum();

	         // Calculate balance amount server-side
	         double balance = paidAmount - total;

	         // Create the invoice
	         InvoiceEntity invoice = new InvoiceEntity();
	         invoice.setInvoiceNumber(invoiceNumber);
	         invoice.setCustomerName(customerName);
	         invoice.setCustomerPhoneNumber(customerPhoneNumber);
	         invoice.setCreationDateTime(LocalDateTime.now());
	         invoice.setTotalAmount(total);
	         invoice.setPaidAmount(paidAmount);
	         invoice.setBalanceAmount(balance);

	         // Add invoice items to the invoice
	         for (InvoiceItemEntity item : invoiceItems) {
	             item.setInvoice(invoice);
	             item.setCreationDateTime(LocalDateTime.now());
	         }
	         invoice.setItems(invoiceItems);

	         // Save the invoice and its items
	         ir.save(invoice);

	         // Deduct quantities from PharmEntity (stock) and update NetTotal
	         for (InvoiceItemEntity item : invoiceItems) {
	             String barcode = item.getBarcode();  // Get product barcode
	             int quantitySold = item.getQuantity(); // Get quantity sold

	             // Fetch product from PharmEntity by barcode
	             List<PharmEntity> products = ps.getProductsByBarcode(barcode);

	             if (!products.isEmpty()) {
	                 PharmEntity product = products.get(0);  // Assuming barcode is unique

	                 int currentQuantity = product.getQuantity();
	                 int updatedQuantity = currentQuantity - quantitySold;

	                 // Prevent quantity from going below zero
	                 updatedQuantity = Math.max(updatedQuantity, 0);

	                 product.setQuantity(updatedQuantity);

	                 // Recalculate NetTotal after quantity update
	                 double costPerUnit = product.getCost();
	                 double gstPercent = product.getGstPercentage();
	                 double gstPerUnit = (costPerUnit * gstPercent) / 100;

	                 double newNetTotal = (costPerUnit + gstPerUnit) * updatedQuantity;
	                 product.setNetTotal(newNetTotal);

	                 // Update product in the database
	                 ps.save(product);

	                 // If the quantity is 0, mark product as out of stock
	                 if (updatedQuantity == 0) {
	                     product.setType("Out of Stock");
	                     ps.save(product); // Save again to update stock status
	                 }
	             }
	         }

	         // Add payment details and invoice info to the model
	         model.addAttribute("paidAmount", paidAmount);
	         model.addAttribute("balanceAmount", balance);
	         model.addAttribute("invoiceNumber", invoiceNumber);
	         model.addAttribute("customerName", customerName);
	         model.addAttribute("customerPhoneNumber", customerPhoneNumber);
	         model.addAttribute("invoiceItems", invoiceItems);
	         model.addAttribute("total", total);
	         model.addAttribute("saveSuccess", "Invoice saved successfully!");

	         // Clear session data
	         session.removeAttribute("invoiceItems");
	         session.removeAttribute("invoiceNumber");
	         session.removeAttribute("customerName");
	         session.removeAttribute("customerPhoneNumber");
	         session.removeAttribute("showCustomer");

	         return "invoice-summery";  // Go to invoice summary page
	     }

	     return "redirect:/create-invoice";  // Redirect if no invoice items are found
	 }


	 @GetMapping("/invoice-list")
	 public String showInvoiceList(Model model) {
	     List<InvoiceEntity> invoices = is.getAllInvoices(); // Fetch invoices and their items
	     model.addAttribute("invoices", invoices);
	     return "invoice-list";
	 }
	 
	 @GetMapping("/invoice/detail/{id}")
	 public String viewInvoice(@PathVariable Long id, Model model) {
	     Optional<InvoiceEntity> invoiceOpt = is.getInvoiceById(id);

	     if (invoiceOpt.isPresent()) {
	         InvoiceEntity invoice = invoiceOpt.get();

	         // Extracting the necessary details
	         String customerName = invoice.getCustomerName();
	         String customerPhoneNumber = invoice.getCustomerPhoneNumber();
	         List<InvoiceItemEntity> invoiceItems = invoice.getItems();
	         double total = invoiceItems.stream()
	                                    .mapToDouble(item -> item.getNetTotal()) // Adjust this if necessary
	                                    .sum();
	         double paidAmount = invoice.getPaidAmount();
	         double balanceAmount = invoice.getBalanceAmount();

	         // Adding attributes to the model
	         model.addAttribute("invoice", invoice); // Pass the entire invoice object
	         model.addAttribute("customerName", customerName);
	         model.addAttribute("customerPhoneNumber", customerPhoneNumber);
	         model.addAttribute("invoiceItems", invoiceItems);
	         model.addAttribute("total", total);
	         model.addAttribute("paidAmount", paidAmount); 
	         model.addAttribute("balanceAmount", balanceAmount);

	         return "invoice-detail"; // Return to the JSP page
	     } else {
	         return "redirect:/invoice-list"; // If no invoice is found, redirect
	     }
	 }
	 
	 @GetMapping("/invoice/delete/{id}")
	 public String deleteInvoice(@PathVariable Long id) {
	     is.deleteInvoice(id); // you must have a service method to delete
	     return "redirect:/invoice-list"; // redirect back to list page after deletion
	 }


}





	 

