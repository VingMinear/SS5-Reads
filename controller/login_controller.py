from database.db import PgConfig


class LoginDao:
    def verify_auth(self,logindto):
        cur=PgConfig.getCursor()
        cur.execute("select * from tbluser where is_active=true and uname=%s and upass=%s", (logindto.UName, logindto.UPass))
        if (cur.rowcount > 0):
            import random;
            val = random.randrange(100000, 999999);
            cur.execute(
                "update tbluser set confirm_code=%s,code_exp=now()+'5 minutes'::interval where is_active=true and uname=%s and upass=%s"
                , (str(val), logindto.UName, logindto.UPass)
                )
            PgConfig.PgCommit();
            return True;
        else:
            return False;

    def confirm_code(self,logindto):
        cur=PgConfig.getCursor();
        cur.execute("select * from tbluser where is_active=true and uname=%s and upass=%s and confirm_code=%s and now()<=code_exp", (logindto.UName, logindto.UPass,logindto.ConfirmCode))
        if cur.rowcount > 0:
            return True
        else:
            return False
