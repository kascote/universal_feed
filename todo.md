# TODO

ATOM
  content
    4.1.3.2.  The "src" Attribute

      atom:content MAY have a "src" attribute, whose value MUST be an IRI
      reference [RFC3987].  If the "src" attribute is present, atom:content
      MUST be empty.  Atom Processors MAY use the IRI to retrieve the
      content and MAY choose to ignore remote content or to present it in a
      different manner than local content.

      If the "src" attribute is present, the "type" attribute SHOULD be
      provided and MUST be a MIME media type [MIMEREG], rather than "text",
      "html", or "xhtml".  The value is advisory; that is to say, when the
      corresponding URI (mapped from an IRI, if necessary) is dereferenced,
      if the server providing that content also provides a media type, the
      server-provided media type is authoritative.

