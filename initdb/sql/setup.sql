--  -*- text -*-
--
-- admin.sql -- MySQL commands for creating the RADIUS user.
--
--	WARNING: You should change 'localhost' and 'radpass'
--		 to something else.  Also update raddb/mods-available/sql
--		 with the new RADIUS password.
--
--	$Id: 6198ed795d0b5a035c19635fef992589c7d676e1 $
--

--
--  Create default administrator for RADIUS
--
CREATE USER 'radius'@'localhost' IDENTIFIED BY 'radpass';

-- The server can read any table in SQL
GRANT SELECT ON radius.* TO 'radius'@'localhost';

-- The server can write to the accounting and post-auth logging table.
--
-- i.e.
GRANT ALL on radius.radacct TO 'radius'@'localhost';
GRANT ALL on radius.radpostauth TO 'radius'@'localhost';
