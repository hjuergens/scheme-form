# scheme-form
This project provided a XML-Transformation to translate a XSD -a XML schema definition- into
a HTML-form. At this stage it's not more as a template for further development.
It's far from a real world application.

Example
-------
The XSD fragment

    <xs:element name="person">
        <xs:complexType>
            <xs:all>
                <xs:element name="firstName" type="xs:string"/>
                <xs:element name="lastName" type="xs:string"/>
            </xs:all>
        </xs:complexType>
    </xs:element>

will be transformed into the HTML fragment

    <form id="N65536">
        <fieldset form="N65536" name="" id="person">
            <legend>Person</legend>
            <label for="personFirstName">Person FirstName
                <input type="text" class="form-control" id="personFirstName"/>
            </label>
            <label for="personLastName">Person LastName
                <input type="text" class="form-control" id="personLastName"/>
            </label>
        </fieldset>
    </form>

