package com.axsos.project.services;

import java.util.List;
import java.util.Optional;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.axsos.project.dto.EditStoreForm;
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

    // all stores, used to fill the "Store" filter on the Products page
    public List<Store> getAllStores() {
        return storeRepository.findAll();
    }

    // one store by id, freshly loaded from the database. Used whenever a page
    // needs a store's lazy collections (like its products) - the Store object
    // cached in the session was loaded during an earlier request, and its
    // Hibernate session is already closed, so lazy fields on it can't be
    // read anymore (see LazyInitializationException). Re-fetching here gets
    // a copy tied to the current request's Hibernate session instead.
    public Optional<Store> getStoreById(Long id) {
        return storeRepository.findById(id);
    }

    // Updates the store's public info (name, description, phone, address)
    // from the Edit Store form - same "copy fields onto the real entity,
    // then save" pattern as CustomerService.updateProfile.
    public Store updateStoreProfile(Store store, EditStoreForm form) {
        store.setStoreName(form.getStoreName());
        store.setDescription(form.getDescription());
        store.setPhone(form.getPhone());
        store.setAddress(form.getAddress());
        return storeRepository.save(store);
    }

}