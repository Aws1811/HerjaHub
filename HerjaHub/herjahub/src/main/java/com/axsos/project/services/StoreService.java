package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.RegistrationForm;
import com.axsos.project.dto.StorePageForm;
import com.axsos.project.dto.StoreProfileForm;
import com.axsos.project.models.Store;
import com.axsos.project.repositores.StoreRepository;


@Service
public class StoreService {
    @Autowired
    private StoreRepository storeRepository;

    public boolean emailExists(String email) {
        return storeRepository.existsByEmail(email);
    }

    public Optional<Store> findById(Long id) {
        return storeRepository.findById(id);
    }

    // same as findById, but with the products collection already initialized -
    // use this whenever a view needs to read store.getProducts() (e.g. fn:length(store.products))
    public Store findByIdWithProducts(Long id) {
        return storeRepository.findByIdWithProducts(id).orElse(null);
    }

    // every store on the platform, used by the customer-facing "All Stores" page
    // and the dashboard's featured-stores preview. JpaRepository already gives us
    // findAll(), this just reads more intentionally at the call site.
    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }

    // Updates the editable profile fields (never touches email or password here)
    public Store updateProfile(Store store, StoreProfileForm form) {
        store.setFirstName(form.getFirstName());
        store.setLastName(form.getLastName());
        store.setStoreName(form.getStoreName());
        store.setDescription(form.getDescription());
        store.setPhone(form.getPhone());
        store.setAddress(form.getAddress());
        if (form.getImage() != null && !form.getImage().isBlank()) {
            store.setImage(form.getImage());
        }
        return storeRepository.save(store);
    }

    // Updates the editable profile fields from the Edit Store page (imageUrl null keeps the existing logo)
    public Store updateProfileFromPage(Store store, StorePageForm form, String imageUrl) {
        store.setFirstName(form.getFirstName());
        store.setLastName(form.getLastName());
        store.setStoreName(form.getStoreName());
        store.setDescription(form.getDescription());
        store.setPhone(form.getPhone());
        store.setAddress(form.getAddress());
        if (imageUrl != null) {
            store.setImage(imageUrl);
        }
        return storeRepository.save(store);
    }

    // Verifies the current password, then sets the new (hashed) one
    public boolean changePassword(Store store, String currentPassword, String newPassword) {
        if (!BCrypt.checkpw(currentPassword, store.getPassword())) {
            return false;
        }
        store.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        storeRepository.save(store);
        return true;
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
