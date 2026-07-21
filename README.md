# HerjaHub

HerjaHub is a web-based marketplace platform that supports Palestinian artisans by giving them an online space to showcase and sell their handmade products. Customers can browse stores and products, manage a cart, and place orders. Store owners can manage their own storefront and products.

This project was built as part of an academy full-stack track, using Java (Spring Boot) on the backend and JSP on the frontend.

## Team

- Aws Sleebi
- Hosni Ahmed
- Abdallah Awad

## Tech Stack

- Java 17+ / Spring Boot 3.5
- Spring MVC (controllers, view resolution)
- Spring Data JPA / Hibernate
- MySQL
- JSP + JSTL (views)
- jBCrypt (password hashing)
- Maven

## Features

### Customer

- Register and log in
- Browse all products, with a filter by store
- View a single product's details and existing comments
- Add products to a cart (kept in the session until checkout)
- Checkout, which converts the cart into a real order
- View order history and a single order's confirmation/summary
- Edit profile (name, email, password)

### Store Owner

- Register and log in
- View a dashboard listing their own products and how many units of each have sold
- Add a new product
- View and edit an existing product
- Edit their store's public info (name, description, phone, address)

### Shared

- Role-based authentication (Customer vs Store Owner), stored in the HTTP session
- Passwords are hashed with BCrypt, never stored in plain text
- Ownership checks on edit routes, so a store owner cannot view or edit another store's product by changing the URL


## Getting Started

### Prerequisites

- Java 17 or newer
- Maven
- MySQL running locally

### Setup

1. Clone the repository
2. Create a MySQL database for the project
3. Set your database credentials in `src/main/resources/application.properties`
4. Run the application from your IDE, or with:
   ```
   mvn spring-boot:run
   ```
5. The app runs on `http://localhost:8080` by default


## Planned / Future Work

The following were part of the original project scope but are not implemented yet:

- AI-powered gift recommendation assistant
- Product ratings
- Store owners responding to customer comments
- Payment gateway integration
- Wishlist / favorites
- Multi-language support (Arabic and English)
- Delivery tracking

## Links

- Trello board: https://trello.com/b/TIXm8VbF/the-legend-of-all
- Project wiki: see the Wiki tab of this repository
