public without sharing class contactList {
    public contact[] contacts {get; private set;}
    public string firstName {get; set;}
    public string lastName {get; set;}
    public string accountName {get; set;}
    public contactList() {
        filter();
    }
    
    public void filter() {
        string query = 'select id, name, email, phone, title, account.name, accountId from contact';
        
        query += queryFilter();
        
        contacts = database.query(query);
    }

    public string queryFilter() {
        string[] filters = new string[] {};
        if (string.isNotBlank(firstName)) {
            filters.add('firstName = :firstName');
        }
        if (string.isNotBlank(lastName)) {
            filters.add('lastName = :lastName');
        }
        if (string.isNotBlank(accountName)) {
            filters.add('account.name like \'%' + accountName + '%\'');
        }
        string filter = string.join(filters, ' and ');

        return string.isNotBlank(filter) ? ' where ' + filter : '';
    }
}
