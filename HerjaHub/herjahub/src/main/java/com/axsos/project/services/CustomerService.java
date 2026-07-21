package com.axsos.project.services;

import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.EditProfileForm;
import com.axsos.project.dto.RegistrationForm;
import com.axsos.project.models.Customer;
import com.axsos.project.repositores.CustomerRepository;

@Service
public class CustomerService {
	@Autowired
    private CustomerRepository customerRepository;

    public boolean emailExists(String email) {
        return customerRepository.existsByEmail(email);
    }

    // Saves a new customer using the values entered in the registration form
    public Customer registerCustomer(RegistrationForm form) {
        Customer customer = new Customer();
        customer.setFirstName(form.getFirstName());
        customer.setLastName(form.getLastName());
        customer.setEmail(form.getEmail());
        customer.setPassword(BCrypt.hashpw(form.getPassword(), BCrypt.gensalt())); // hashed, never store plain text
        return customerRepository.save(customer);
    }

    // Looks up the customer by email and checks the password matches
    public Optional<Customer> login(String email, String password) {
        Optional<Customer> customerOpt = customerRepository.findByEmail(email);

        if (customerOpt.isPresent()) {
            Customer customer = customerOpt.get();
            if (BCrypt.checkpw(password, customer.getPassword())) {
                return customerOpt;
            }
        }

        return Optional.empty();
    }

    // verifies a raw password against the customer's stored (hashed) password -
    // used by Edit Profile before allowing a password change
    public boolean checkPassword(Customer customer, String rawPassword) {
        if (rawPassword == null || customer.getPassword() == null) {
            return false;
        }
        return BCrypt.checkpw(rawPassword, customer.getPassword());
    }

    // Updates an existing customer's info from the Edit Profile form.
    // If newPassword is left blank, the current password is kept as-is.
    public Customer updateProfile(Customer customer, EditProfileForm form) {
        customer.setFirstName(form.getFirstName());
        customer.setLastName(form.getLastName());
        customer.setEmail(form.getEmail());

        if (form.getNewPassword() != null && !form.getNewPassword().isBlank()) {
            customer.setPassword(BCrypt.hashpw(form.getNewPassword(), BCrypt.gensalt()));
        }

        return customerRepository.save(customer);
    }
}
