# Architecting Elixir Applications with OTP

This repository contains a demonstration app for the Pluralsight course _Architecting Elixir Applications with OTP_.

It has the following parts (in order of construction):

* **Core**: A functional core containing data structures representing visitors, events, and attractions.
* **Boundary**: A process layer with an event manager and visitor session processes.
* **Persistence**: A service for persisting data to PostgreSQL.
* **Web**: A Phoenix API for interacting with the system.

Terminology and layout for this example application were influenced by the book
[_Designing Elixir Systems with OTP_](https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/)
by James Edward Gray, II and Bruce A. Tate.
