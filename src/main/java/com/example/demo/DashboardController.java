package com.example.demo;


import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DashboardController {

    @Autowired
    private PharmRepository pharmRepository;

    @Autowired
    private InvoiceRespo invoiceRespo;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private UserRepository userRepository; 
   
   
    
    @GetMapping("/")
    public String Default() {
       
    	return "register";  // Show the register page if the user is not logged in
    }
    
 
    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";  // Returns the register.jsp page
    }

    // Handle register form submission
    @PostMapping("/register")
    public String registerUser(UserEntity user, Model model) {
        String message = userService.registerUser(user);
        model.addAttribute("message", message);  // Add message to the model to show on the JSP page
        return "login";  // Return back to the register page with message
    }

    // Display login form
    @GetMapping("/login")
    public String showLoginForm() {
        return "login";  // Returns the login.jsp page
    }

    // Handle login form submission
    @PostMapping("/login")
    public String loginUser(String email, String password, Model model) {
        Optional<UserEntity> user = userService.loginUser(email, password);
        
        if (user.isPresent()) {
            // If login is successful, redirect to home or dashboard page
            return "redirect:/dashboard";  // Redirect to a home page (create a home.jsp page as needed)
        } else {
            // If login fails, display an error message
            model.addAttribute("message", "Invalid email or password.");
            return "login";  // Return to login page with error message
        }
    }
    
    
    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        // Show forgot password form (just an example)
        return "forgotPassword"; // Create a JSP or HTML page for resetting password
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam String email, Model model) {
        // Logic to send reset email (you would need to implement this)
        boolean emailSent = userService.sendPasswordResetEmail(email);

        if (emailSent) {
            model.addAttribute("msg", "A password reset link has been sent to your email.");
        } else {
            model.addAttribute("msg", "Error: Email not found or issue with sending reset link.");
        }

        return "forgotPassword";
    }
    
    @RequestMapping(value = "/reset-password", method = RequestMethod.GET)
    public String resetPasswordPage(@RequestParam("token") String token, Model model) {
        // Handle the reset page (show form to input new password)
        model.addAttribute("token", token);
        return "resetPassword";  // Your reset password page
    }

    @RequestMapping(value = "/reset-password", method = RequestMethod.POST)
    public String processResetPassword(@RequestParam("token") String token, @RequestParam("newPassword") String newPassword, Model model) {
        // Handle the password reset (update the user's password)
        Optional<UserEntity> user = userRepository.findByResetToken(token);
        if (user.isPresent()) {
            UserEntity userEntity = user.get();
            userEntity.setPassword(newPassword);
            userEntity.setResetToken(null);  // Clear the reset token
            userRepository.save(userEntity);
            model.addAttribute("msg", "Password reset successfully.");
        } else {
            model.addAttribute("msg", "Invalid reset token.");
        }
        return "login";  // Redirect to login after resetting the password
    }
	
	
	
	
	
	 
    @GetMapping("/dashboard")
    public String dashboard(Model model) {

        long totalProducts = pharmRepository.count(); // Count all products
        long totalInvoices = invoiceRespo.count();    // Total number of invoices
        Double totalSales = invoiceRespo.sumOfTotalAmount();  // Total sales amount

        long inStockCount = pharmRepository.countByQuantityGreaterThan(0); // In Stock
        long outOfStockCount = pharmRepository.countByQuantity(0);         // Out of Stock
        long lowStockCount = pharmRepository.countByQuantityLessThan(10);  // Low Stock

        // Fetch today's invoices and sales
        long todayInvoices = invoiceRespo.countTodayInvoices();
        Double todaySales = invoiceRespo.sumTodaySales();

        if (totalSales == null) totalSales = 0.0;
        if (todaySales == null) todaySales = 0.0;

        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("totalInvoices", totalInvoices);
        model.addAttribute("totalSales", totalSales);
        model.addAttribute("inStockCount", inStockCount);
        model.addAttribute("outOfStockCount", outOfStockCount);
        model.addAttribute("lowStockCount", lowStockCount);
        
        // Add today's data
        model.addAttribute("todayInvoices", todayInvoices);
        model.addAttribute("todaySales", todaySales);

        return "Dashboard";
    }
    
    
 // Filtered product list based on stock type
    @GetMapping("/product/filter")
    public String filterProducts(@RequestParam("type") String type, Model model) {
        List<PharmEntity> filteredProducts = null;

        // Determine the stock type and get the respective list
        switch (type) {
            case "inStock":
                filteredProducts = pharmRepository.findByQuantityGreaterThan(0);
                break;
            case "outOfStock":
                filteredProducts = pharmRepository.findByQuantity(0);
                break;
            case "lowStock":
                filteredProducts = pharmRepository.findByQuantityLessThan(10);
                break;
        }

        model.addAttribute("filteredProducts", filteredProducts);
        return "dashProductList"; // assuming you have a "ProductList.jsp" to display the filtered products
    }
    
    
    
    @GetMapping("/todaysInvoices")
    public String getTodaysInvoices(Model model) {
        // Get today's date (only date part, no time)
        LocalDate today = LocalDate.now();

        // Convert to start and end of today
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.plusDays(1).atStartOfDay();

        // Fetch invoices created today using between
        List<InvoiceEntity> todayInvoices = invoiceRespo.findByCreationDateTimeBetween(startOfDay, endOfDay);

        // Ensure that you load the items (invoice items) with the invoice
        for (InvoiceEntity invoice : todayInvoices) {
            // Force loading the items if not fetched eagerly
            invoice.getItems().size();  // Trigger loading of the invoice items
        }

        model.addAttribute("todaysInvoices", todayInvoices);
        return "todayInvoiceList"; // JSP page for today's invoice list
    }



    
    
}
    
    

