public without sharing class contact_list {
    public contact[] contacts;
    public contact_list() {
        contacts = [select id, name, email, phone, title, account.name, accountId from contact];
    }

    public contact[] get_contacts(){
        return contacts;
    }
}