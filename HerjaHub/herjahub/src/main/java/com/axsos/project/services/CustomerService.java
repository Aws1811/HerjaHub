package com.axsos.project.services;

import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
