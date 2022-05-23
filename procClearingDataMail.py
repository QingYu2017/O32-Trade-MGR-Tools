import re,quopri,poplib
import datetime
from cls_mail import fun_save_file
from cls_mail import fun_get_value
from cls_mail import fun_decode_base64
from email.header import decode_header
from email.parser import Parser


# ---------------------------------------------------------------------------
# Define the business date, defaults to the current date
# ---------------------------------------------------------------------------
proc_date = '20220520'
if len(proc_date) == 0:
    proc_date = datetime.datetime.now().strftime('%Y%m%d')

# ---------------------------------------------------------------------------
# Define search variables with regular expressions
# ---------------------------------------------------------------------------
str_search = '水泊梁山基金管理有限公司.*{}|{}.*[account1|account2|account3]|[account1|account2|account3]-{}'.format(proc_date,proc_date,proc_date)

# ---------------------------------------------------------------------------
# Fetch mail data, only fetch head information if with head_only 
# ---------------------------------------------------------------------------
def f_fetch_mail(srv, i, proctype = 'head_only'):
    if proctype != "head_only":
        m = srv.retr(i)  #Fetch full mail data
    else:
        m = srv.top(i,0)  #Fetch head data only 
    hdr,lines,octets=m
    msg = b'\r\n'.join(lines).decode('utf-8')   # Decode message and parse to message object
    msg=Parser().parsestr(msg)
    return m,msg

# ---------------------------------------------------------------------------
# Decode input string based on its characters
# ---------------------------------------------------------------------------
def decode_str(s):
    value, charset = decode_header(s)[0]
    if charset:
        value = value.decode(charset)
    return value

# ---------------------------------------------------------------------------
# Parser mail sender, receiver and sbuject from import mail content
# ---------------------------------------------------------------------------
def fun_fetch_mail_subject(msg):
    info= {}
    for header in ['From','To','Subject','Message-ID','Date']:
        info[header] = m[header]
    mail_subject = re.sub('\r| ','',m['Subject']).split('\n')
    info['Subject_decode'] = ''.join([fun_decode_base64(x) for x in mail_subject])
    return info

# ---------------------------------------------------------------------------
# Define variables
# ---------------------------------------------------------------------------
host,username,password=(fun_get_value('mail_server'),fun_get_value('mail_username'),fun_get_value('mail_password'))

# ---------------------------------------------------------------------------
# Create connection with pop server
# ---------------------------------------------------------------------------
server = poplib.POP3(host)  

# ---------------------------------------------------------------------------
# Login pop server
# ---------------------------------------------------------------------------
server.user(username)
server.pass_(password)
resp, mails, octets = server.list()

# ---------------------------------------------------------------------------
# Traverse the emails, get and extractthe specified email attachment
# ---------------------------------------------------------------------------
index = len(mails)
for i in range(index, index- 30, -1):
    m = f_fetch_mail(server,i)[1]
    m_title = fun_fetch_mail_subject(m)
    #print(m_title)
    print('Fetching mail：{}'.format(m_title['Subject_decode']))
    if len(re.findall(str_search, m_title['Subject_decode']))>0:
        print('{} Parsing mail：{}'.format('>'*10,m_title['Subject_decode']))
        m_full = f_fetch_mail(server,i,'full')
        for part in m_full[1].walk():
            if part.get_filename():
                f = decode_header(part.get_filename())
                if f[0][1]:
                    filename = f[0][0].decode(f[0][1])
                else:
                    filename = f[0][0]
                filedata = part.get_payload(decode=True)
                fun_save_file(filedata, filename, '{}_clearingdata'.format(proc_date))
