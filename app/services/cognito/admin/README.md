# Cognito Admin

This file contains documentation on the three modules/classes which make up Cognito Admin:
- [`UserClientInterface`](#user-client-interface)
- [`User`](#user)
- [`Roles`](#roles)

These modules allow us to more easily interact with [AWS Cognito SDK](https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CognitoIdentityProvider/Client.html) and manage our users.

## User Client Interface

The `UserClientInterface` is a module which provides an interface with the AWS Cognito SDK.
It is mainly meant to be used within the [`User`](#user) class as that class tries to act as similar to a Rails `ActiveModel/ActiveRecord` as possible.

### Class methods

#### find_user_from_cognito_uuid
View [source](user_client_interface.rb#L6)

Finds the user from the Cognito UUID.
If it is able to find the user it will return the user attributes in a hash:
```ruby
{
  cognito_uuid: String,
  email: String,
  telephone_number: String,
  account_status: Boolean,
  confirmation_status: String,
  mfa_enabled: Boolean,
  roles: Array[String],
  service_access: Array[String]
}
```

If no user is found, or an exception is raised by AWS Cognito, an error hash is returned:
```ruby
{
  error: String
}
```

#### create_user_and_return_errors
View [source](user_client_interface.rb#L14)

Takes the following params:
- `attributes` - the user attributes used to create the user
- `enable_mfa` - a flag to enable the Multi Factor Authentication
and creates the user in AWS Cognito.

The `attributes` parameter is a hash which can have the following keys:
```ruby
{
  email: String,
  telephone_number: String,
  groups: Array[String]
}
```

If the user is created successfully, then the method returns `nil`
If an exception is raised by AWS Cognito when creating a user, the error message is returned.

#### find_users_from_email
View [source](user_client_interface.rb#L27)

Finds the users in AWS Cognito who's email starts with the `email` prefix param.
If it is able to find users, it will return the hash `{ users: Array[Hash] }`.
If no users are found, the `users` array will be empty.

A `user` in the `users` array will be a hash with the following attributes:
```ruby
{
  cognito_uuid: UUID,
  email: String,
  account_status: Boolean,
}
```

If an exception is raised by AWS Cognito, an error hash is returned along with an empty users array:
```ruby
{
  users: []
  error: String
}
```

#### user_with_email_exists
View [source](user_client_interface.rb#L41)

Takes the `email` as a param and tries to find a user in AWS Cognito with that exact email.
It returns a hash:
```ruby
{
  result: Boolean,
}
```
where the `result` is a flag to indicate if a user with that email already exists.

If an exception is raised by AWS Cognito, an error hash is returned:
```ruby
{
  error: String
}
```

#### update_user_and_return_errors
View [source](user_client_interface.rb#L57)

Takes the following params:
- `cognito_uuid` - the Cognito UUID of the user to update
- `attributes` - the user attributes that will be updated
- `method` - the type of update that needs to be made
and updates the users attributes in AWS Cognito depending on the `method` passed.

Allowed values for the `method` are:
- `:account_status` - will enable or disable the account
- `:telephone_number` - updates the telephone number
- `:mfa_enabled` - will enable or disable the Multi Factor Authentication for the account
- `:roles` - updates the role groups for the user
- `:service_access` - updates the service access groups for the user

If the user is updated successfully, then the method returns `nil`
If an exception is raised by AWS Cognito when updating a user, the error message is returned.

## User

`User` is a class that is used for working with the user data from AWS Cognito.
It is meant to act as close as possible to a Rails `ActiveModel/ActiveRecord` and should be used in a similar way.
It makes use of the [`UserClientInterface`](#user-client-interface) to interact with AWS Cognito instead of connecting to a database.

One of the quirks of the user model is the requirement that the ability of the user trying to manage the user determines some of the characteristics of the model.
All admin users can view any user but admin users can only manage, that is create or update, users who are on a level below them.
Because this affects things like validation, the `current_user_access` is required when initialising the model, as well as the actual attributes of the user.

### Attributes

The user model has the following attributes:

| Attribute           | Type          | Status  | Description                                                                               |
| ------------------- | ------------- | ------- | ----------------------------------------------------------------------------------------- |
| cognito_uuid        | String        | private | Cognito UUID of the user                                                                  |
| email               | String        | public  | email of the user                                                                         |
| account_status      | Boolean       | public  | flag to indicate if the account is enabled or disabled                                    |
| confirmation_status | String        | public  | status of an account, mainly used to determine of an account can have it's password reset |
| mfa_enabled         | Boolean       | public  | flag to indicate if the MFA is enabled or disabled                                        |
| roles               | Array[String] | public  | the roles of the user                                                                     |
| service_access      | Array[String] | public  | the service access of the user                                                            |
| cognito_roles       | Roles         | public  | manages the [`Roles`](#roles) of the user                                                 |
| telephone_number    | String        | public  | telephone number of the user                                                              |
| origional_groups    | Array[String] | private | used to help validate and update the groups                                               |

Like a Rails `ActiveModel/ActiveRecord`, most of these attributes will also have validations to check the values that are being assigned to them.

### Initialization
View [source](user.rb#L48)

The following params are required to initialise the user:
- `current_user_access` - the access of the application user attempting to find the user
- `attributes` - hash of the user attributes to be assigned to the model (default: `{}`)

If there is an issue, such as an unexpected attribute or an attribute is of an incompatible type, an error will be raised and will put the user into an error state.
This means it cannot be updated.

If there are no issues then a new `User` object will be created with all the attributes that were passed in assigned to the object.
The object can then be used in a similar way to a Rails `ActiveModel/ActiveRecord`.

### Class methods

#### find
view [source](user.rb#L38)

Takes the following params:
- `current_user_access` - the access of the user attempting to find the user
- `cognito_uuid` - Cognito UUID of the user
and will find the user in AWS Cognito and initialise them as a `User`.

If the user cannot be found in AWS Cognito, the `User` is still created but in an error state (i.e. it has errors) and so cannot be managed.

#### search
View [source](user.rb#L42)

Finds the users in AWS Cognito who's email starts with the passed in `email` prefix param.

If the email is blank, it will return an error hash along with an empty users array:
```ruby
{
  users: []
  error: String
}
```

If the email is not blank, then it will call [`find_users_from_email`](#find_users_from_email) from the `UserClientInterface`.

### Instance methods

#### assign_attributes
View [source](user.rb#L57)

Takes in a hash of key (attribute) value pairs and will attempt to assign the attributes in the model.

If the attributes passed are not in a hash format, then an `ArgumentError` is raised.
If an unexpected attribute is passed, an `ActiveRecord::UnknownAttributeError` is raised.

Assuming the attributes hash is fine then the attributes in the object will be updated.
This includes making sure that attributes are cast to the correct type where possible, i.e. converting `'true'` to `true`.


#### create
View [source](user.rb#L72)

Will attempt to create the user in AWS Cognito with the current attribute values in the object.
It will return `true` if the user was successfully created, otherwise it returns `false`.

The method will first attempt to validate the object.
If it is valid then it will call [`create_user_and_return_errors`](#create_user_and_return_errors) from the `UserClientInterface`.
If an error is returned then this is added to the object.
If no error was returned this means the user was successfully created in AWS Cognito and the method returns `true`.

#### update
View [source](user.rb#L82)

This takes the update `method` as an argument and will attempt to update the user in AWS Cognito with the current attribute values in the object.
It will return `true` if the user was successfully updated, otherwise it returns `false`.

The method will first attempt to validate the object on the update `method` context.
If it is valid then it will call [`update_user_and_return_errors`](#update_user_and_return_errors) from the `UserClientInterface`.
If an error is returned then this is added to the object.
If no error was returned this means the user was successfully updated in Cognito and the method can return `true`.

#### `cognito_attributes`
View [source](user.rb#L163)

This is a private method which converts the current attributes of the object into a hash that can be used by the `UserClientInterface`.
This is required because there is not always a one to one mapping of attributes in the `User` model that can be used by the AWS Cognito SDK.

As an example, where AWS Cognito has a single set of `groups`, we split them into two sets, the `roles` and the `service_access`.
We do this because, from a system perspective, they are easier to manage.
Because of this mismatch, we use `cognito_attributes` so that the `roles` and the `service_access` are combined into a single `groups` attribute.

## Roles

The `Roles` class is used to help manage the `roles` and `service_access` of the user.

The `roles` determine which areas (buyer side, admin side) that the user is able to access and what they can do in those areas.
They are as follows:
- Buyer - can access the buyer section of a service
- Supplier - can access the supplier section of a service
- Service admin - can access the admin section of a service
- User support - can manage only Buyer users and view the allow list
- User admin - can manage nearly all users and can manage the allow list

The `service_access` determines which services the user can access.
Buyers and Service admins require this information.
They are as follows:
- Facilities Management
- Legal Services
- Management Consultancy
- Supply Teachers

The main purpose of the `Roles` class is for use in the `User` class to validate the user `roles` and `service_access`.
This includes:
- validation that the application user managing the `User` has the ability to assign the selected roles
- validation that the selected `roles` are real
- validation that the selected `service_access` are real

### Instance methods

#### get_roles_and_service_access_from_cognito_roles
View [source](roles.rb#L46)

This takes the single `groups` array provided by AWS Cognito and splits them into `roles` and `service_access`, which are then returned as separate arrays.
It will also ignore any `groups` that we are not expecting.

#### current_user_access
View [source](roles.rb#L53)

This takes the `current_user_ability` as a param and then determines what kind of access the user has.
Note, the abilities are defined in the [`Ability`](../../../models/ability.rb) class.

The possible return values are:
- `:super_admin` - 
- `:user_admin`
- `:user_support`
- `nil`

This is important for determining what kind of users the current user can manage.

#### find_available_roles
View [source](roles.rb#L63)

This takes the [`current_user_access`](#current_user_access) as a param and returns the roles that that user is allowed to manage.
The table shows what roles each user type can manage:

| User type     | Types of user they can manage                             |
| ------------- | --------------------------------------------------------- |
| User support  | Buyer                                                     |
| User admin    | Buyer, Supplier, Service admin, User support              |
| Super admin   | Buyer, Supplier, Service admin, User support, User admin  |
