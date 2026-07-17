package com.axsos.project.services;

import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.RegistrationForm;
import com.axsos.project.models.Store;
import com.axsos.project.repositores.StoreRepository;


@Service
public class StoreService {
	@Autowired
    private StoreRepository storeRepository;

    public boolean emailExists(String email) {
        return storeRepository.existsByEmail(email);
    }

    // Saves a new store owner using the values entered in the registration form
    public Store registerStore(RegistrationForm form) {
        Store store = new Store();
        store.setFirstName(form.getFirstName());
        store.setLastName(form.getLastName());
        store.setEmail(form.getEmail());
        store.setPassword(BCrypt.hashpw(form.getPassword(), BCrypt.gensalt())); // hashed, never store plain text
        store.setStoreName(form.getStoreName());
        store.setDescription(form.getDescription());
        store.setPhone(form.getPhone());
        store.setAddress(form.getAddress());
        return storeRepository.save(store);
    }

    // Looks up the store owner by email and checks the password matches
    public Optional<Store> login(String email, String password) {
        Optional<Store> storeOpt = storeRepository.findByEmail(email);

        if (storeOpt.isPresent()) {
            Store store = storeOpt.get();
            if (BCrypt.checkpw(password, store.getPassword())) {
                return storeOpt;
            }
        }

        return Optional.empty();
    }

}
