# README | e-commerce auto
## 1. Description
### This project aims to create an api for manage and visualizing orders and batches of orders. For that, some actions were implemented.

## 2. Project Requirements
### Actions implemented:
- [x] Create a new order
- [x] Get the status of an Order by client name
- [x] List the Orders of a Purchase Channel
- [x] Create a batch for a Purchase Channel
- [x] Produce a Batch 
- [x] Close part of a Batch for a Delivery Service
- [x] Simple financial repport

## 3. Additional Stuff
### Some additional features were implemented to improve the plataform:
- [x] WEB UI page for check all of the orders information
- [x] Search in orders mechanism in WEB UI page
- [x] A authorization layer to allow only registered users to use the api
- [x] Functional tests for Order controller 
- [x] Docker-compose for the application 

## 4. How to run
Clone the repository
```
git clone https://github.com/lucasuf/ecommerce-auto.git
```
Inside the project, build docker image
```
docker-compose build
```
Create, migrate and populate db
```
docker-compose run web rake db:create db:migrate db:seed
```
Start application
```
docker-compose up
```
If you want to run order controller tests:
```
docker-compose run web rails test test/controllers/orders_controller_test.rb
```
### 5. API usage guide
| url  | method   | purpose  |
|---|---|---|
| /  | GET  | This action will render index HTML response if no param is informed.  |
| /orders?purchase_channel=Site%20BR&status=ready  |  GET | Find all the orders for a specific purchase channel and status.  |
| /orders?purchase_channel=Site%20BR |  GET |  Find all the orders for a specific purchase channel. |
| /orders?client_name=Lucas  | GET  | Find all the orders for a specific client.   |
| /orders?report=yes  | GET  |  Generate financial report. |
| /order  |  POST |  This action will create a new order. Body application/json can look like this: {reference": "BR001","purchase_channel": "Site BR","client_name": "Lucas Barros","adress": "Apt. 264 813 Chang Flat, Batzton, RI 64332-0289","delivery_service": "SEDEX","total_value": 59.33,"line_items": "Samuel Smith’s Imperial IPA"}. **All values must be informed and access-token, client and uid must be used on header.** |  
| /batches  | POST  | Create a bacth for purchase channel. Body application/json can look like this: {"purchase_channel_batch": "Site BR"}. **Require access-token, client and uid to be used on header.** |  
| /batches  |  GET |  Return a list of all batches. | 
| /batches/S9748737E  |  PATCH |  Update orders based on the body for order S9748737E. If you want to close your application/json body must look like this {"action_batch": "Close"}. On the other hand, if you want to send, you have to send an application/json like {"action_batch": "Send","delivery_service": "SEDEX"}. **Require access-token, client and uid to be used on header.** | 
|  /auth/sign_in | POST  | Sign in on the plataform. It will return the parameters required on the header of some other actions. When sending the request set Content-Type: application/json and send{ "email": "test@email.com","password": "password"}, for example (using the same credential informed on /auth). This route will return a JSON representation of the User model on successful login along with the access-token,client and uid in the header of the response. **You must use them on the header of your request.**  | 
| /auth  |  POST | Required for most post actions. When sending the request set Content-Type: application/json and send {"email": "test@email.com","password": "password","password_confirmation": "password"}, for example. For more information [check usage guide](https://devise-token-auth.gitbook.io/devise-token-auth/usage). | 