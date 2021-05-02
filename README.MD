autoship.cfm

This file is called when the customer confirms they wish to enroll in autoship at the end of their order.
It updates the database to modify the order from a one time order to an autoship order.

order_edit.cfm

This file is on the backend and displays the details of an order. It contains some calls to the DB to
determine if an order is an autoship order. It also contains the ability to duplicate and order. The
goal of the search files is to bring up autoship orders that need to be placed for that day and then
view the original order and duplicate it.

search.cfm

This file allows you to search for orders in multiple ways on the backend. You can search for orders
that are "autoship" orders.

search_process_as.cfm

This file is executed when searching for autoship orders that need to be placed. It displays all the orders
that are autoship orders and you can then click on an individual order to duplicate it.

shopping_cart_process_dupe.cfm

This file actually performs the details of duplicating an order. It obtains all the information about an order
needed to duplicate it, including the products ordered. It then places then in the shopping cart and you can
checkout. The cusomer information will be pre-populated at checkout and then you place the order.