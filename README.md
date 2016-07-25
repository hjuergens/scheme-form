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
                <xs:element name="firstname" type="xs:string"/>
                <xs:element name="lastname" type="xs:string"/>
            </xs:all>
        </xs:complexType>
    </xs:element>

will be transformed into the HTML fragment

    <form id="N65536">
        <fieldset form="N65536" name="" id="person">
            <legend>Person</legend>
            <label for="personfirstname">personfirstname
                <input type="text" class="form-control" id="personfirstname"/>
            </label>
            <label for="personlastname">personlastname
                <input type="text" class="form-control" id="personlastname"/>
            </label>
        </fieldset>
    </form>

